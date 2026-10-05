import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/ui_state.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/paged_list.dart';
import '../../dues/controller/dues_controller.dart';
import '../../home/controller/home_controller.dart';
import '../../payments/controller/payments_controller.dart';
import '../../transactions/controller/transaction_controller.dart';
import '../model/profile_model.dart';
import '../model/somiti_info_model.dart';
import '../repository/profile_repository.dart';

class ProfileController extends GetxController {
  final IProfileRepository repository;
  final StorageService storageService;

  ProfileController({
    required this.repository,
    required this.storageService,
  });

  final profileState = UIState<ProfileModel>.initial().obs;
  final currentLanguage = 'bn'.obs;

  @override
  void onInit() {
    super.onInit();
    currentLanguage.value = storageService.getLanguageCode();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    profileState.value = UIState.loading();
    final result = await repository.getProfile();
    profileState.value = result.profile != null ? UIState.success(result.profile!) : UIState.error(result.failure ?? const UnknownFailure());
  }

  /// Amounts and labels come from the server in the request language, so everything on screen
  /// is fetched again after a language change.
  Future<void> changeLanguage(String langCode, String countryCode) async {
    currentLanguage.value = langCode;
    await storageService.saveLocale(langCode, countryCode);
    Get.updateLocale(Locale(langCode, countryCode));

    fetchProfile();
    if (Get.isRegistered<HomeController>()) Get.find<HomeController>().fetchSummary();
    if (Get.isRegistered<DuesController>()) Get.find<DuesController>().refreshDues();
    if (Get.isRegistered<PaymentsController>()) Get.find<PaymentsController>().refreshPayments();
    if (Get.isRegistered<TransactionController>()) Get.find<TransactionController>().fetchStatement();
  }

  /// Signs out this device: the backend session first (best effort), then the stored tokens.
  Future<void> logout() async {
    await repository.logout();
    await storageService.clearAuthData();
    Get.offAllNamed(AppRoutes.login);
  }
}

class DividendsController extends GetxController {
  final IProfileRepository repository;

  DividendsController({required this.repository});

  late final PagedList<DividendModel> dividends = PagedList<DividendModel>((page) => repository.getDividends(page: page));

  @override
  void onInit() {
    super.onInit();
    dividends.refresh();
  }
}

class SomitiInfoController extends GetxController {
  final IProfileRepository repository;

  SomitiInfoController({required this.repository});

  final infoState = UIState<SomitiInfoModel>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    infoState.value = UIState.loading();
    final result = await repository.getSomitiInfo();
    infoState.value = result.info != null ? UIState.success(result.info!) : UIState.error(result.failure ?? const UnknownFailure());
  }
}

class ChangePasswordController extends GetxController {
  final IProfileRepository repository;

  ChangePasswordController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isSubmitting = false.obs;
  final failure = Rxn<Failure>();

  String? errorFor(String field) => failure.value?.validationErrors?[field]?.first;

  /// True when saved. Other devices are signed out by the backend; this one stays signed in.
  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    isSubmitting.value = true;
    failure.value = null;
    final result = await repository.changePassword(
      current: currentPasswordController.text,
      password: newPasswordController.text,
      confirmation: confirmPasswordController.text,
    );
    isSubmitting.value = false;
    failure.value = result.failure;

    return result.failure == null;
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
