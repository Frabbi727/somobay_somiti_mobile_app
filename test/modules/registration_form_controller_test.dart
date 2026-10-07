import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_form_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/model/registration_model.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/registration_repository.dart';

import '../support/fixtures.dart';

RegistrationModel invited() => RegistrationModel.fromJson(fixture('registration_invited')['data'] as Map<String, dynamic>);

/// The invited draft with these nominees already saved.
RegistrationModel invitedWithNominees(List<Map<String, dynamic>> nominees) {
  final json = fixture('registration_invited')['data'] as Map<String, dynamic>;
  (json['data'] as Map<String, dynamic>)['nominees'] = nominees;
  return RegistrationModel.fromJson(json);
}

class RecordingRegistrationRepository implements IRegistrationRepository {
  final List<Map<String, dynamic>> saved = [];
  final List<String> submitKeys = [];
  final List<Failure?> answers = [];
  RegistrationModel Function() draft = invited;
  Failure? relationsFailure;

  @override
  Future<RegistrationResult> getRegistration() async => (failure: null, registration: draft());

  @override
  Future<({Failure? failure, List<NomineeRelationModel> relations})> relations() async => relationsFailure != null
      ? (failure: relationsFailure, relations: const <NomineeRelationModel>[])
      : (failure: null, relations: const [NomineeRelationModel(id: 3, key: 'spouse', label: 'স্বামী/স্ত্রী')]);

  @override
  Future<RegistrationResult> saveDraft(Map<String, dynamic> fields) async {
    saved.add(fields);
    final failure = answers.isEmpty ? null : answers.removeAt(0);
    return (failure: failure, registration: failure == null ? invited() : null);
  }

  @override
  Future<RegistrationResult> submit(String idempotencyKey) async {
    submitKeys.add(idempotencyKey);
    final failure = answers.isEmpty ? null : answers.removeAt(0);
    return (failure: failure, registration: failure == null ? invited() : null);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('starts from the saved draft', () async {
    final controller = RegistrationFormController(repository: RecordingRegistrationRepository());
    await controller.load();

    expect(controller.nameBnController.text, 'করিম মিয়া');
    expect(controller.mobile.value, '01811111111');
    expect(controller.relations.single.label, 'স্বামী/স্ত্রী');
    expect(controller.nominees, hasLength(1)); // one empty row to start with
  });

  test('saves only the current step and moves on', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository)..skipValidationForTests = true;
    await controller.load();
    controller.nameEnController.text = 'Karim Mia';

    expect(await controller.next(), isTrue);
    expect(repository.saved.single.keys, containsAll(['name_bn', 'name_en', 'guardian_name', 'nid', 'date_of_birth']));
    expect(repository.saved.single['name_en'], 'Karim Mia');
    expect(controller.currentStep.value, 1);
  });

  test('stays on the step with the typed values when the network is down', () async {
    final repository = RecordingRegistrationRepository()..answers.add(const NetworkFailure());
    final controller = RegistrationFormController(repository: repository)..skipValidationForTests = true;
    await controller.load();
    controller.nameEnController.text = 'Karim Mia';

    expect(await controller.next(), isFalse);
    expect(controller.currentStep.value, 0);
    expect(controller.nameEnController.text, 'Karim Mia');
    expect(controller.failure.value, isA<NetworkFailure>());
  });

  test('sends nominees as the API expects', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository)..skipValidationForTests = true;
    await controller.load();
    controller.currentStep.value = 2;
    controller.nominees.first
      ..nameController.text = 'করিমা'
      ..relationId.value = 3
      ..nidController.text = '১২৩৪৫৬৭৮৯০'
      ..shareController.text = '১০০';

    await controller.next();

    expect(repository.saved.single, {
      'nominees': [
        {'name': 'করিমা', 'relation_id': 3, 'nid': '1234567890', 'mobile': null, 'share_percent': '100'},
      ],
    });
  });

  test('reuses the submit key after a failure and renews it after success', () async {
    final repository = RecordingRegistrationRepository()..answers.addAll([const TimeoutFailure(), null, null]);
    final controller = RegistrationFormController(repository: repository);
    await controller.load();

    expect(await controller.submit(), isFalse);
    expect(await controller.submit(), isTrue);
    expect(await controller.submit(), isTrue);

    expect(repository.submitKeys[0], repository.submitKeys[1]);
    expect(repository.submitKeys[2], isNot(repository.submitKeys[1]));
  });

  test('clears a saved nominee relation that is no longer offered', () async {
    final repository = RecordingRegistrationRepository()
      ..draft = () => invitedWithNominees([
            {'name': 'করিমা', 'relation_id': 3, 'share_percent': '50'},
            {'name': 'রহিম', 'relation_id': 99, 'share_percent': '50'},
          ]);
    final controller = RegistrationFormController(repository: repository);
    await controller.load();

    expect(controller.nominees.map((row) => row.relationId.value), [3, null]);
  });

  test('ends in the error state (with Retry) when the relations cannot be loaded', () async {
    final repository = RecordingRegistrationRepository()..relationsFailure = const NetworkFailure();
    final controller = RegistrationFormController(repository: repository);
    await controller.load();

    expect(controller.loadState.value.isError, isTrue);
    expect(controller.loadState.value.failure, isA<NetworkFailure>());
  });

  test('a field error with no place on the current step is passed on as a message', () async {
    final repository = RecordingRegistrationRepository()
      ..answers.addAll([
        const ValidationFailure(message: 'invalid', errors: {'nominees.0.nid': ['NID is already used.']}),
        const ValidationFailure(message: 'invalid', errors: {'nominees.5.nid': ['Unknown row.']}),
      ]);
    final controller = RegistrationFormController(repository: repository)..skipValidationForTests = true;
    await controller.load();
    controller.currentStep.value = 2;

    await controller.next();
    expect(controller.unshownValidationMessage(2), isNull); // shown under the nominee's NID

    await controller.next();
    expect(controller.unshownValidationMessage(2), 'Unknown row.');
  });

  test('adds up nominee shares in hundredths without floating point', () {
    expect(percentToHundredths('100'), 10000);
    expect(percentToHundredths('৩৩.৩'), 3330);
    expect(percentToHundredths('66.67'), 6667);
    expect(percentToHundredths('12.345'), isNull);
    expect(percentToHundredths('abc'), isNull);
  });
}
