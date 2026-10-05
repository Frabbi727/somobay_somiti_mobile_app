import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../../../core/widgets/app_network_banner.dart';
import '../controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppNetworkBanner(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Logo & Header
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_rounded,
                            size: 42,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'auth_login_title'.tr,
                          style: AppTextStyles.h1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'auth_login_subtitle'.tr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Phone Input
                      AppTextField(
                        label: 'auth_phone_label'.tr,
                        hint: 'auth_phone_hint'.tr,
                        controller: controller.phoneController,
                        validator: AppValidator.validatePhone,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 18),

                      // Sign-in method (only when the society allows SMS codes)
                      Obx(() => controller.otpEnabled.value
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: SegmentedButton<bool>(
                                segments: [
                                  ButtonSegment(value: false, label: Text('auth_use_password'.tr), icon: const Icon(Icons.lock_outline_rounded)),
                                  ButtonSegment(value: true, label: Text('auth_use_code'.tr), icon: const Icon(Icons.sms_outlined)),
                                ],
                                selected: {controller.useCode.value},
                                onSelectionChanged: (selection) => controller.setUseCode(selection.first),
                              ),
                            )
                          : const SizedBox.shrink()),

                      Obx(() => controller.useCode.value ? _codeField() : _passwordField()),
                      const SizedBox(height: 12),

                      // Remember me
                      Row(
                        children: [
                          Obx(() => SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: controller.rememberMe.value,
                                  onChanged: controller.toggleRememberMe,
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              )),
                          const SizedBox(width: 8),
                          Text(
                            'auth_remember_me'.tr,
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Login Button
                      Obx(() => AppButton.primary(
                            text: 'auth_login_button'.tr,
                            isLoading: controller.loginState.value.isLoading,
                            onPressed: controller.login,
                          )),
                      const SizedBox(height: 24),

                      // Passwords are set by the society office (no self-registration or reset)
                      Text(
                        'auth_password_help'.tr,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField() {
    return AppTextField(
      label: 'auth_password_label'.tr,
      hint: 'auth_password_hint'.tr,
      controller: controller.passwordController,
      validator: AppValidator.validatePassword,
      obscureText: !controller.isPasswordVisible.value,
      isRequired: true,
      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
      suffixIcon: IconButton(
        icon: Icon(
          controller.isPasswordVisible.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.textSecondary,
        ),
        onPressed: controller.togglePasswordVisibility,
      ),
    );
  }

  Widget _codeField() {
    return AppTextField(
      label: 'auth_code_label'.tr,
      hint: 'auth_code_hint'.tr,
      controller: controller.codeController,
      validator: (value) => (value == null || value.trim().isEmpty) ? 'auth_code_required'.tr : null,
      keyboardType: TextInputType.number,
      isRequired: true,
      prefixIcon: const Icon(Icons.sms_outlined, color: AppColors.textSecondary),
      suffixIcon: TextButton(
        onPressed: controller.resendIn.value > 0 || controller.sendingCode.value ? null : controller.sendCode,
        child: Text(
          controller.resendIn.value > 0
              ? 'auth_resend_in'.trParams({'seconds': '${controller.resendIn.value}'})
              : 'auth_send_code'.tr,
        ),
      ),
    );
  }
}
