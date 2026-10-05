import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
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

                      // Password Input
                      Obx(() => AppTextField(
                            label: 'auth_password_label'.tr,
                            hint: 'auth_password_hint'.tr,
                            controller: controller.passwordController,
                            validator: AppValidator.validatePassword,
                            obscureText: !controller.isPasswordVisible.value,
                            isRequired: true,
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textSecondary),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          )),
                      const SizedBox(height: 12),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.forgotPassword),
                            child: Text(
                              'auth_forgot_password'.tr,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

                      // Register Navigation Prompt
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'auth_register_prompt'.tr,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed(AppRoutes.register),
                            child: Text(
                              'auth_register_now'.tr,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
}
