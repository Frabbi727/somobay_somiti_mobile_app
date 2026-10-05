import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/models/ui_state.dart';
import '../../../core/services/storage_service.dart';
import '../model/user_profile_model.dart';
import '../repository/profile_repository.dart';

class ProfileController extends GetxController {
  final IProfileRepository repository;
  final StorageService storageService;

  ProfileController({
    required this.repository,
    required this.storageService,
  });

  final profileState = UIState<UserProfileModel>.initial().obs;
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

    if (result.failure != null) {
      profileState.value = UIState.error(result.failure!);
    } else if (result.profile != null) {
      profileState.value = UIState.success(result.profile!);
    } else {
      profileState.value = UIState.empty();
    }
  }

  Future<void> changeLanguage(String langCode, String countryCode) async {
    currentLanguage.value = langCode;
    await storageService.saveLocale(langCode, countryCode);
    Get.updateLocale(Locale(langCode, countryCode));
  }

  Future<void> logout() async {
    await storageService.clearAuthData();
    Get.offAllNamed(AppRoutes.login);
  }
}

class ChangePasswordController extends GetxController {
  final IProfileRepository repository;
  ChangePasswordController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final isSubmitting = false.obs;

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    isSubmitting.value = true;
    final result = await repository.changePassword(
      currentPasswordController.text,
      newPasswordController.text,
    );
    isSubmitting.value = false;

    if (result.isSuccess) {
      Get.back();
      Get.snackbar(
        'সফল',
        'পাসওয়ার্ড সফলভাবে পরিবর্তন করা হয়েছে।',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
