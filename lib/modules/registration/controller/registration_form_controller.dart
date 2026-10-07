import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/utils/image_compressor.dart';
import '../model/registration_model.dart';
import '../repository/registration_repository.dart';
import 'nominee_form_row.dart';

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

  RegistrationFormController({required this.repository});

  static const stepLabels = [
    'registration_step_personal',
    'registration_step_contact',
    'registration_step_nominees',
    'registration_step_shares',
    'registration_step_review',
  ];

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

  final nameBnController = TextEditingController();
  final nameEnController = TextEditingController();
  final guardianController = TextEditingController();
  final nidController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final sharesController = TextEditingController();

  String _idempotencyKey = const Uuid().v4();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loadState.value = UIState.loading();
    final relationList = await repository.relations();
    final result = await repository.getRegistration();

    if (result.registration == null) {
      loadState.value = UIState.error(result.failure ?? relationList.failure ?? const UnknownFailure());
      return;
    }

    relations.assignAll(relationList.relations);
    final data = result.registration!.data;
    nameBnController.text = data.nameBn ?? '';
    nameEnController.text = data.nameEn ?? '';
    guardianController.text = data.guardianName ?? '';
    nidController.text = data.nid ?? '';
    emailController.text = data.email ?? '';
    addressController.text = data.address ?? '';
    sharesController.text = data.requestedShares?.toString() ?? '';
    dateOfBirth.value = data.dateOfBirth;
    photoUrl.value = data.photoUrl;
    mobile.value = data.mobile;
    for (final row in nominees) {
      row.dispose();
    }
    nominees.assignAll(data.nominees.isEmpty ? [NomineeFormRow()] : data.nominees.map(NomineeFormRow.fromModel));
    loadState.value = UIState.success(result.registration!);
  }

  String? errorFor(String field) => failure.value?.validationErrors?[field]?.first;

  int get nomineeTotalHundredths => nominees.fold(0, (total, row) => total + (percentToHundredths(row.shareController.text) ?? 0));

  void addNominee() => nominees.add(NomineeFormRow());

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
      1 => {'email': _text(emailController), 'address': _text(addressController)},
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
    if (submitting.value) return false;

    submitting.value = true;
    failure.value = null;
    final result = await repository.submit(_idempotencyKey);
    submitting.value = false;

    if (result.failure != null) {
      failure.value = result.failure;
      return false;
    }

    _idempotencyKey = const Uuid().v4();
    return true;
  }

  @override
  void onClose() {
    for (final controller in [nameBnController, nameEnController, guardianController, nidController, emailController, addressController, sharesController]) {
      controller.dispose();
    }
    for (final row in nominees) {
      row.dispose();
    }
    super.onClose();
  }
}
