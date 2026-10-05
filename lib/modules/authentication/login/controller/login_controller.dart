import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/models/ui_state.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/bangla_number_util.dart';
import '../../model/login_request_model.dart';
import '../../repository/auth_repository.dart';

class LoginController extends GetxController {
  final IAuthRepository repository;
  final StorageService storageService;

  LoginController({
    required this.repository,
    required this.storageService,
  });

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final rememberMe = true.obs;
  final loginState = UIState<bool>.initial().obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? val) {
    rememberMe.value = val ?? false;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    loginState.value = UIState.loading();
    final cleanPhone = BanglaNumberUtil.toEnglish(phoneController.text.trim());
    final request = LoginRequestModel(
      phone: cleanPhone,
      password: passwordController.text,
    );

    final result = await repository.login(request);

    if (result.failure != null) {
      loginState.value = UIState.error(result.failure!);
      Get.snackbar(
        'ত্রুটি',
        result.failure!.message.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } else if (result.tokens != null) {
      await storageService.saveTokens(
        access: result.tokens!.accessToken,
        refresh: result.tokens!.refreshToken,
      );
      loginState.value = UIState.success(true);
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
