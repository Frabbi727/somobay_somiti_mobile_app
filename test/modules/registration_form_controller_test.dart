import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/address_form_state.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_form_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/model/registration_model.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/registration_repository.dart';

import '../support/fake_geo_repository.dart';
import '../support/fake_terms_repository.dart';
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
  final List<int> submitVersions = [];
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
  Future<RegistrationResult> submit(String idempotencyKey, int termsVersion) async {
    submitKeys.add(idempotencyKey);
    submitVersions.add(termsVersion);
    final failure = answers.isEmpty ? null : answers.removeAt(0);
    return (failure: failure, registration: failure == null ? invited() : null);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('starts from the saved draft', () async {
    final controller = RegistrationFormController(repository: RecordingRegistrationRepository(), geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
    await controller.load();

    expect(controller.nameBnController.text, 'করিম মিয়া');
    expect(controller.mobile.value, '01811111111');
    expect(controller.relations.single.label, 'স্বামী/স্ত্রী');
    expect(controller.nominees, hasLength(1)); // one empty row to start with
  });

  test('saves only the current step and moves on', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
    await controller.load();
    controller.nameEnController.text = 'Karim Mia';

    expect(await controller.next(), isTrue);
    expect(repository.saved.single.keys, containsAll(['name_bn', 'name_en', 'guardian_name', 'nid', 'date_of_birth']));
    expect(repository.saved.single['name_en'], 'Karim Mia');
    expect(controller.currentStep.value, 1);
  });

  test('stays on the step with the typed values when the network is down', () async {
    final repository = RecordingRegistrationRepository()..answers.add(const NetworkFailure());
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
    await controller.load();
    controller.nameEnController.text = 'Karim Mia';

    expect(await controller.next(), isFalse);
    expect(controller.currentStep.value, 0);
    expect(controller.nameEnController.text, 'Karim Mia');
    expect(controller.failure.value, isA<NetworkFailure>());
  });

  test('sends nominees as the API expects', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
    await controller.load();
    controller.currentStep.value = 2;
    controller.nominees.first
      ..nameController.text = 'করিমা'
      ..relationId.value = 3
      ..nidController.text = '১২৩৪৫৬৭৮৯০'
      ..shareController.text = '১০০';

    await controller.next();

    final nominee = (repository.saved.single['nominees'] as List).single as Map<String, dynamic>;
    expect(nominee, containsPair('name', 'করিমা'));
    expect(nominee, containsPair('nid', '1234567890'));
    expect(nominee, containsPair('share_percent', '100'));
  });

  /// A saved draft whose member and nominee both live at Gulshan-1.
  RegistrationModel Function() draftAtGulshan() => () {
    final json = fixture('registration_submitted')['data'] as Map<String, dynamic>;
    return RegistrationModel.fromJson(json);
  };

  test('contact step sends gender, passport and both addresses', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
    await controller.load();
    controller.currentStep.value = 1;
    controller.person.gender.value = 'male';
    controller.person.passportController.text = 'ab 123456';
    await controller.person.present.selectDivision(6);
    await controller.person.present.selectDistrict(47);
    await controller.person.present.selectUpazila(495);
    controller.person.present.selectUnion(4541);
    controller.person.present.lineController.text = 'House 12';
    controller.person.permanent.lineController.text = 'Village Road';
    await controller.person.permanent.selectDivision(6);
    await controller.person.permanent.selectDistrict(47);
    await controller.person.permanent.selectUpazila(496); // Banani has no unions

    await controller.next();

    expect(repository.saved.single, {
      'email': null,
      'gender': 'male',
      'passport_no': 'AB123456',
      'present_upazila_id': 495,
      'present_union_id': 4541,
      'present_address_line': 'House 12',
      'permanent_upazila_id': 496,
      'permanent_union_id': null,
      'permanent_address_line': 'Village Road',
      'permanent_same_as_present': false,
    });
    expect(repository.saved.single.containsKey('address'), isFalse);
  });

  test('same as present copies the present address', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
    await controller.load();
    controller.currentStep.value = 1;
    final person = controller.person;
    await person.present.selectDivision(6);
    await person.present.selectDistrict(47);
    await person.present.selectUpazila(495);
    person.present.selectUnion(4542);
    person.present.lineController.text = 'Road 5';

    person.setSameAsPresent(true);

    expect(person.permanent.upazilaId.value, 495);
    expect(person.permanent.unionId.value, 4542);
    expect(person.permanent.lineController.text, 'Road 5');

    person.present.lineController.text = 'Road 6'; // edited after ticking: the sent copy follows
    await controller.next();
    expect(repository.saved.single['permanent_address_line'], 'Road 6');
    expect(repository.saved.single['permanent_union_id'], 4542);
    expect(repository.saved.single['permanent_same_as_present'], isTrue);
  });

  test('changing district clears upazila and union', () async {
    final address = AddressFormState(geo: FakeGeoRepository());
    await address.selectDivision(6);
    await address.selectDistrict(47);
    await address.selectUpazila(495);
    address.selectUnion(4541);
    expect(address.unionsAvailable.value, isTrue);

    final reload = address.selectDistrict(52);
    expect(address.districtId.value, 52, reason: 'the choice is set before the child list loads');
    expect(address.upazilaId.value, isNull);
    expect(address.unionId.value, isNull);
    expect(address.unions.places, isEmpty);
    expect(address.unionsAvailable.value, isFalse);
    await reload;
    expect(address.upazilas.places, isEmpty);
  });

  test('an upazila without unions leaves the union optional', () async {
    final address = AddressFormState(geo: FakeGeoRepository());
    await address.selectDivision(6);
    await address.selectDistrict(47);
    await address.selectUpazila(496);

    expect(address.unionsAvailable.value, isFalse);
    expect(address.toJson('present')['present_union_id'], isNull);
  });

  test('a failed unions load leaves availability unknown, keeps the union and can be retried', () async {
    final geo = FakeGeoRepository()..unionsFailure = const NetworkFailure();
    final address = AddressFormState(geo: geo);
    await address.selectDivision(6);
    await address.selectDistrict(47);
    address.unionId.value = 4541; // as loaded from a saved draft
    await address.selectUpazila(495);
    address.unionId.value = 4541;

    expect(address.unions.failure.value, isA<NetworkFailure>());
    expect(address.unionsLoaded.value, isFalse);
    expect(address.unionsAvailable.value, isFalse);
    expect(address.unionRequired, isTrue);
    expect(address.toJson('present')['present_union_id'], 4541, reason: 'the saved union is not erased while the list is unknown');

    geo.unionsFailure = null;
    await address.reloadUnions();

    expect(address.unions.failure.value, isNull);
    expect(address.unionsLoaded.value, isTrue);
    expect(address.unionsAvailable.value, isTrue);
  });

  test('a late unions answer for an earlier upazila is dropped', () async {
    final geo = FakeGeoRepository();
    final address = AddressFormState(geo: geo);
    await address.selectDivision(6);
    await address.selectDistrict(47);
    final gate = Completer<void>();
    geo.unionsGates.add(gate);

    final first = address.selectUpazila(495);
    await address.selectUpazila(496); // Banani: no unions
    gate.complete();
    await first;

    expect(address.upazilaId.value, 496);
    expect(address.unions.places, isEmpty);
    expect(address.unionsLoaded.value, isTrue);
    expect(address.unionsAvailable.value, isFalse);
  });

  test('nominee row sends its addresses', () async {
    final repository = RecordingRegistrationRepository();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
    await controller.load();
    controller.currentStep.value = 2;
    final row = controller.nominees.first;
    row.nameController.text = 'করিমা';
    row.person.gender.value = 'female';
    row.person.passportController.text = 'x9y8z7w6';
    await row.person.present.selectDivision(6);
    await row.person.present.selectDistrict(47);
    await row.person.present.selectUpazila(495);
    row.person.present.selectUnion(4541);
    row.person.present.lineController.text = 'Flat 4';
    row.person.setSameAsPresent(true);

    await controller.next();

    final nominee = (repository.saved.single['nominees'] as List).single as Map<String, dynamic>;
    expect(nominee, containsPair('gender', 'female'));
    expect(nominee, containsPair('passport_no', 'X9Y8Z7W6'));
    expect(nominee, containsPair('present_upazila_id', 495));
    expect(nominee, containsPair('present_union_id', 4541));
    expect(nominee, containsPair('present_address_line', 'Flat 4'));
    expect(nominee, containsPair('permanent_upazila_id', 495));
    expect(nominee, containsPair('permanent_address_line', 'Flat 4'));
    expect(nominee, containsPair('permanent_same_as_present', true));
  });

  test('loading a saved draft fills the whole address chain', () async {
    final repository = RecordingRegistrationRepository()..draft = draftAtGulshan();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
    await controller.load();

    final present = controller.person.present;
    expect([present.divisionId.value, present.districtId.value, present.upazilaId.value, present.unionId.value], [6, 47, 495, 4541]);
    expect(present.lineController.text, 'House 12, Road 3');
    expect(present.districts.places.any((p) => p.id == 47), isTrue);
    expect(present.upazilas.places.any((p) => p.id == 495), isTrue);
    expect(present.unions.places.any((p) => p.id == 4541), isTrue);
    expect(present.unionsAvailable.value, isTrue);
    expect(controller.person.gender.value, 'male');
    expect(controller.person.permanentSameAsPresent.value, isTrue);
    expect(controller.person.present.summary('en'), 'House 12, Road 3, Gulshan-1, Gulshan, Dhaka, Dhaka');

    final nominee = controller.nominees.single.person;
    expect(nominee.gender.value, 'female');
    expect(nominee.present.unionId.value, 4541);
    expect(nominee.present.unions.places, isNotEmpty);
  });

  test('server errors for the new fields are shown on their steps', () async {
    final controller = RegistrationFormController(repository: RecordingRegistrationRepository(), geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
    await controller.load();

    expect(controller.errorKeysShownOn(1), containsAll(['gender', 'passport_no', 'present_upazila_id', 'present_union_id', 'permanent_address_line', 'permanent_same_as_present']));
    expect(controller.errorKeysShownOn(1), isNot(contains('address')));
    expect(controller.errorKeysShownOn(2), containsAll(['nominees.0.gender', 'nominees.0.present_upazila_id', 'nominees.0.permanent_union_id', 'nominees.0.passport_no']));
  });

  test('reuses the submit key after a failure and renews it after success', () async {
    final repository = RecordingRegistrationRepository()..answers.addAll([const TimeoutFailure(), null, null]);
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
    await controller.load();
    await controller.loadTerms();
    controller.termsAgreed.value = true;

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
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
    await controller.load();

    expect(controller.nominees.map((row) => row.relationId.value), [3, null]);
  });

  test('ends in the error state (with Retry) when the relations cannot be loaded', () async {
    final repository = RecordingRegistrationRepository()..relationsFailure = const NetworkFailure();
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
    await controller.load();

    expect(controller.loadState.value.isError, isTrue);
    expect(controller.loadState.value.failure, isA<NetworkFailure>());
  });

  test('a field error with no place on the current step is passed on as a message', () async {
    final repository = RecordingRegistrationRepository()
      ..answers.addAll([
        const ValidationFailure(
          message: 'invalid',
          errors: {
            'nominees.0.nid': ['NID is already used.'],
          },
        ),
        const ValidationFailure(
          message: 'invalid',
          errors: {
            'nominees.5.nid': ['Unknown row.'],
          },
        ),
      ]);
    final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository())..skipValidationForTests = true;
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

  group('rules agreement', () {
    test('submit sends the rules version', () async {
      final repository = RecordingRegistrationRepository();
      final terms = FakeTermsRepository()..version = 5;
      final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: terms);
      await controller.load();
      await controller.loadTerms();
      controller.termsAgreed.value = true;

      expect(await controller.submit(), isTrue);
      expect(repository.submitVersions, [5]);
    });

    test('submit is blocked until the rules are ticked', () async {
      final repository = RecordingRegistrationRepository();
      final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
      await controller.load();

      expect(await controller.submit(), isFalse, reason: 'rules not loaded');
      await controller.loadTerms();
      expect(await controller.submit(), isFalse, reason: 'box not ticked');
      expect(repository.submitKeys, isEmpty);
    });

    test('outdated version reloads the rules', () async {
      final repository = RecordingRegistrationRepository()..answers.add(const ValidationFailure(message: 'The rules changed.'));
      final terms = FakeTermsRepository();
      final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: terms);
      await controller.load();
      await controller.loadTerms();
      controller.termsAgreed.value = true;
      terms.version = 4; // the somiti published new rules meanwhile

      expect(await controller.submit(), isFalse);

      expect(controller.terms.value!.version, 4);
      expect(controller.termsAgreed.value, isFalse);
      expect(controller.rulesChanged.value, isTrue);
      expect(controller.failure.value!.message, 'The rules changed.');
      // The old key belonged to version 3: agreeing again uses a new one.
      controller.termsAgreed.value = true;
      expect(await controller.submit(), isTrue);
      expect(repository.submitVersions, [3, 4]);
      expect(repository.submitKeys[1], isNot(repository.submitKeys[0]));
    });

    test('a refusal with the same rules version is shown as usual', () async {
      final repository = RecordingRegistrationRepository()..answers.add(const ValidationFailure(message: 'Something else.'));
      final controller = RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository(), termsRepository: FakeTermsRepository());
      await controller.load();
      await controller.loadTerms();
      controller.termsAgreed.value = true;

      expect(await controller.submit(), isFalse);

      expect(controller.termsAgreed.value, isTrue);
      expect(controller.rulesChanged.value, isFalse);
      expect(controller.failure.value!.message, 'Something else.');
    });

    test('the rules are loaded when the review step opens', () async {
      final terms = FakeTermsRepository();
      final controller = RegistrationFormController(repository: RecordingRegistrationRepository(), geoRepository: FakeGeoRepository(), termsRepository: terms)..onInit();
      await Future<void>.delayed(Duration.zero);
      controller.currentStep.value = 4;
      await Future<void>.delayed(Duration.zero);

      expect(terms.currentCalls, 1);
      expect(controller.terms.value!.version, 3);
    });
  });
}
