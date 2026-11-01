import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/utils/image_compressor.dart';
import '../../terms/model/terms_model.dart';
import '../../terms/repository/terms_repository.dart';
import '../model/registration_model.dart';
import '../repository/geo_repository.dart';
import '../repository/registration_repository.dart';
import 'nominee_form_row.dart';
import 'person_form_state.dart';

/// "33.3" → 3330 hundredths of a percent (100% = 10000). Null when it is not a percentage with at
/// most two decimals. Integers only: the app never does floating-point arithmetic on shares.
int? percentToHundredths(String text) {
  final value = BanglaNumberUtil.toEnglish(text.trim());
  final match = RegExp(r'^(\d{1,3})(?:\.(\d{1,2}))?$').firstMatch(value);
  if (match == null) return null;
  return int.parse(match.group(1)!) * 100 + int.parse((match.group(2) ?? '0').padRight(2, '0'));
}

/// The member's own registration in five steps. Each "next" saves that step's fields as a draft on
/// the server, so nothing is lost if the app closes. Submit uses one idempotency key per form.
class RegistrationFormController extends GetxController {
  final IRegistrationRepository repository;
  final IGeoRepository geoRepository;
  final ITermsRepository termsRepository;

  RegistrationFormController({required this.repository, required this.geoRepository, required this.termsRepository}) : person = PersonFormState(geo: geoRepository);

  /// The member's own gender, passport and addresses.
  final PersonFormState person;

  static const stepLabels = ['registration_step_personal', 'registration_step_contact', 'registration_step_nominees', 'registration_step_shares', 'registration_step_review'];

  /// Lets unit tests drive steps without a widget tree (the Form widgets validate in the app).
  @visibleForTesting
  bool skipValidationForTests = false;

  final formKeys = List.generate(4, (_) => GlobalKey<FormState>());
  final currentStep = 0.obs;
  final loadState = UIState<RegistrationModel>.initial().obs;
  final relations = <NomineeRelationModel>[].obs;
  final nominees = <NomineeFormRow>[].obs;
  final mobile = ''.obs;
  final dateOfBirth = RxnString();
  final photoUrl = RxnString();
  final saving = false.obs;
  final submitting = false.obs;
  final failure = Rxn<Failure>();

  /// The rules the applicant must agree to on the review step, and whether they ticked the box.
  final terms = Rxn<TermsModel>();
  final termsAgreed = false.obs;
  final termsLoading = false.obs;
  final termsFailure = Rxn<Failure>();

  /// True when the last submit was refused because the rules changed; the page shows the new ones.
  final rulesChanged = false.obs;

  final nameBnController = TextEditingController();
  final nameEnController = TextEditingController();
  final guardianController = TextEditingController();
  final nidController = TextEditingController();
  final emailController = TextEditingController();
  final sharesController = TextEditingController();

  String _idempotencyKey = const Uuid().v4();

  @override
  void onInit() {
    super.onInit();
    // The rules are loaded when the review step opens.
    ever(currentStep, (step) {
      if (step == stepLabels.length - 1) loadTerms();
    });
    load();
  }

  /// Loads the current rules; a newer version than the one shown clears the agreement.
  Future<void> loadTerms() async {
    termsLoading.value = true;
    termsFailure.value = null;
    final result = await termsRepository.current();
    termsLoading.value = false;

    if (result.terms == null) {
      termsFailure.value = result.failure ?? const UnknownFailure();
      return;
    }

    if (terms.value?.version != result.terms!.version) {
      termsAgreed.value = false;
      // The server ties an idempotency key to one rules version.
      _idempotencyKey = const Uuid().v4();
    }
    terms.value = result.terms;
  }

  Future<void> load() async {
    loadState.value = UIState.loading();
    final relationList = await repository.relations();
    // Without the relations the nominee step cannot be filled in: show the error with Retry.
    if (relationList.failure != null) {
      loadState.value = UIState.error(relationList.failure!);
      return;
    }

    final result = await repository.getRegistration();
    if (result.registration == null) {
      loadState.value = UIState.error(result.failure ?? const UnknownFailure());
      return;
    }

    relations.assignAll(relationList.relations);
    final data = result.registration!.data;
    nameBnController.text = data.nameBn ?? '';
    nameEnController.text = data.nameEn ?? '';
    guardianController.text = data.guardianName ?? '';
    nidController.text = data.nid ?? '';
    emailController.text = data.email ?? '';
    sharesController.text = data.requestedShares?.toString() ?? '';
    dateOfBirth.value = data.dateOfBirth;
    photoUrl.value = data.photoUrl;
    mobile.value = data.mobile;
    for (final row in nominees) {
      row.dispose();
    }
    nominees.assignAll(data.nominees.isEmpty ? [_newNominee()] : data.nominees.map((nominee) => NomineeFormRow.fromModel(nominee, geo: geoRepository)));
    await Future.wait([
      person.load(savedGender: data.gender, savedPassport: data.passportNo, savedPresent: data.presentAddress, savedPermanent: data.permanentAddress),
      for (final row in nominees) row.geoReady,
    ]);
    // A saved relation that is no longer offered must be chosen again (the dropdown cannot show it).
    final relationIds = relations.map((relation) => relation.id).toSet();
    for (final row in nominees) {
      if (!relationIds.contains(row.relationId.value)) {
        row.relationId.value = null;
      }
    }
    loadState.value = UIState.success(result.registration!);
  }

  String? errorFor(String field) => failure.value?.validationErrors?[field]?.first;

  static const addressKeys = [
    'gender',
    'passport_no',
    'present_upazila_id',
    'present_union_id',
    'present_address_line',
    'permanent_upazila_id',
    'permanent_union_id',
    'permanent_address_line',
    'permanent_same_as_present',
  ];

  static const nomineeFields = ['name', 'relation_id', 'nid', 'mobile', 'share_percent', ...addressKeys];

  /// The 422 field keys the page shows under the fields of [step].
  Set<String> errorKeysShownOn(int step) => switch (step) {
    0 => {'name_bn', 'name_en', 'guardian_name', 'nid', 'date_of_birth'},
    1 => {'email', ...addressKeys},
    2 => {
      'nominees',
      for (var i = 0; i < nominees.length; i++)
        for (final field in nomineeFields) 'nominees.$i.$field',
    },
    3 => {'requested_shares'},
    _ => const <String>{},
  };

  /// The first 422 message when none of the errors has a place on [step], so it can be shown
  /// another way; null when there are no field errors or one of them is already visible.
  String? unshownValidationMessage(int step) {
    final errors = failure.value?.validationErrors;
    if (errors == null || errors.isEmpty) return null;
    final shown = errorKeysShownOn(step);
    if (errors.keys.any(shown.contains)) return null;
    for (final messages in errors.values) {
      if (messages.isNotEmpty) return messages.first;
    }
    return failure.value!.message;
  }

  int get nomineeTotalHundredths => nominees.fold(0, (total, row) => total + (percentToHundredths(row.shareController.text) ?? 0));

  NomineeFormRow _newNominee() {
    final row = NomineeFormRow(geo: geoRepository);
    row.loadGeo();
    return row;
  }

  void addNominee() => nominees.add(_newNominee());

  void removeNominee(int index) {
    if (nominees.length <= 1) return;
    nominees.removeAt(index).dispose();
  }

  String? _text(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  /// The fields that belong to [step], in the API's names.
  Map<String, dynamic> fieldsFor(int step) {
    final nid = _text(nidController);
    return switch (step) {
      0 => {
        'name_bn': _text(nameBnController),
        'name_en': _text(nameEnController),
        'guardian_name': _text(guardianController),
        'nid': nid == null ? null : BanglaNumberUtil.toEnglish(nid),
        'date_of_birth': dateOfBirth.value,
      },
      1 => {'email': _text(emailController), ...person.toJson()},
      2 => {'nominees': nominees.map((row) => row.toJson()).toList()},
      3 => {'requested_shares': int.tryParse(BanglaNumberUtil.toEnglish(sharesController.text.trim()))},
      _ => const <String, dynamic>{},
    };
  }

  /// Validates and saves the current step; moves on when the server accepted it.
  Future<bool> next() async {
    final step = currentStep.value;
    if (step >= formKeys.length) return false;
    if (!skipValidationForTests && !(formKeys[step].currentState?.validate() ?? false)) return false;

    saving.value = true;
    failure.value = null;
    final result = await repository.saveDraft(fieldsFor(step));
    saving.value = false;

    if (result.failure != null) {
      failure.value = result.failure;
      return false;
    }

    currentStep.value = step + 1;
    return true;
  }

  void back() {
    if (currentStep.value > 0) currentStep.value--;
  }

  /// From the review step: jump back to a step to edit it.
  void goTo(int step) {
    if (step < currentStep.value) currentStep.value = step;
  }

  /// Compresses and uploads the photo; returns a translation key for the problem, or null.
  Future<String?> attachPhoto(String path) async {
    final compressed = await ImageCompressor.compressToLimit(path);
    if (compressed == null) return 'pay_proof_unreadable';

    saving.value = true;
    final result = await repository.uploadPhoto(compressed);
    saving.value = false;

    if (result.failure != null) {
      failure.value = result.failure;
      return result.failure!.message;
    }

    photoUrl.value = result.registration!.data.photoUrl;
    return null;
  }

  /// True when the registration was submitted (it now waits for the first approver).
  Future<bool> submit() async {
    final sentTerms = terms.value;
    if (submitting.value || sentTerms == null || !termsAgreed.value) return false;

    submitting.value = true;
    failure.value = null;
    rulesChanged.value = false;
    final result = await repository.submit(_idempotencyKey, sentTerms.version);
    submitting.value = false;

    if (result.failure != null) {
      failure.value = result.failure;
      await _reloadRulesIfOutdated(result.failure!, sentTerms.version);
      return false;
    }

    _idempotencyKey = const Uuid().v4();
    return true;
  }

  /// The server sends no code for "the rules changed", only a 422 without field errors. So after such
  /// a refusal the current version is asked again; if it differs, the new rules are shown and the box is unticked.
  Future<void> _reloadRulesIfOutdated(Failure refused, int sentVersion) async {
    final isRefusalWithoutFields = (refused.statusCode == 422 || refused.statusCode == 409) && (refused.validationErrors?.isEmpty ?? true);
    if (!isRefusalWithoutFields) return;

    final result = await termsRepository.current();
    if (result.terms == null || result.terms!.version == sentVersion) return;

    terms.value = result.terms;
    termsAgreed.value = false;
    rulesChanged.value = true;
    _idempotencyKey = const Uuid().v4();
    if (refused.message.isEmpty) {
      failure.value = const ValidationFailure(message: 'terms_rules_changed');
    }
  }

  @override
  void onClose() {
    for (final controller in [nameBnController, nameEnController, guardianController, nidController, emailController, sharesController]) {
      controller.dispose();
    }
    for (final row in nominees) {
      row.dispose();
    }
    person.dispose();
    super.onClose();
  }
}
