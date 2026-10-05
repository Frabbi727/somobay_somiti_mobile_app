import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/models/ui_state.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/bangla_number_util.dart';
import '../../model/login_request_model.dart';
import '../../repository/auth_repository.dart';
import 'package:somobay_somiti_mobile_app/core/utils/snackbar_margin.dart';

class LoginController extends GetxController {
  final IAuthRepository repository;
  final StorageService storageService;

  LoginController({
    required this.repository,
    required this.storageService,
  });

  static const resendSeconds = 60;

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final codeController = TextEditingController();

  final isPasswordVisible = false.obs;
  final rememberMe = true.obs;
  final loginState = UIState<bool>.initial().obs;

  /// SMS-code sign-in is offered only when the society has switched it on.
  final otpEnabled = false.obs;
  final useCode = false.obs;
  final sendingCode = false.obs;
  final resendIn = 0.obs;
  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    otpEnabled.value = storageService.getBool(StorageKeys.otpEnabled);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? val) {
    rememberMe.value = val ?? false;
  }

  void setUseCode(bool value) {
    useCode.value = value && otpEnabled.value;
  }

  String get _mobile => BanglaNumberUtil.toEnglish(phoneController.text.trim());

  Future<void> sendCode() async {
    if (sendingCode.value || resendIn.value > 0) return;

    sendingCode.value = true;
    final result = await repository.sendCode(_mobile);
    sendingCode.value = false;

    if (result.failure != null) {
      _showFailure(result.failure!, field: 'mobile');
      return;
    }

    _snack('common_success_title'.tr, 'auth_code_sent'.tr, Colors.green.shade700);
    resendIn.value = resendSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendIn.value--;
      if (resendIn.value <= 0) timer.cancel();
    });
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    loginState.value = UIState.loading();
    final request = useCode.value
        ? LoginRequestModel(mobile: _mobile, code: BanglaNumberUtil.toEnglish(codeController.text.trim()))
        : LoginRequestModel(mobile: _mobile, password: passwordController.text);

    final result = await repository.login(request);

    if (result.failure != null) {
      loginState.value = UIState.error(result.failure!);
      _showFailure(result.failure!, field: useCode.value ? 'code' : 'mobile');
    } else if (result.tokens != null) {
      await storageService.saveTokens(
        access: result.tokens!.accessToken,
        refresh: result.tokens!.refreshToken,
      );
      loginState.value = UIState.success(true);
      Get.offAllNamed(AppRoutes.dashboard);
    }
  }

  /// Shows the backend's own message (already in the member's language); for 422 the field message.
  void _showFailure(Failure failure, {required String field}) {
    final fieldMessage = failure.validationErrors?[field]?.first ?? failure.validationErrors?.values.first.first;
    _snack('common_error_title'.tr, (fieldMessage ?? failure.message).tr, Colors.red.shade800);
  }

  void _snack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: snackbarMargin(),
    );
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    phoneController.dispose();
    passwordController.dispose();
    codeController.dispose();
    super.onClose();
  }
}
