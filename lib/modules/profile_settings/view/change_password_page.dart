import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_fields.dart';
import '../controller/profile_controller.dart';
import 'package:somobay_somiti_mobile_app/core/utils/snackbar_margin.dart';

/// Change the member's own password (minimum 6 characters, as the backend requires).
class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_change_password'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    label: 'password_current'.tr,
                    controller: controller.currentPasswordController,
                    obscureText: true,
                    isRequired: true,
                    validator: (v) => (v == null || v.isEmpty) ? 'validation_required'.tr : null,
                  ),
                  _error('current_password'),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'password_new'.tr,
                    controller: controller.newPasswordController,
                    obscureText: true,
                    isRequired: true,
                    validator: AppValidator.validatePassword,
                  ),
                  _error('password'),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'password_confirm'.tr,
                    controller: controller.confirmPasswordController,
                    obscureText: true,
                    isRequired: true,
                    validator: (v) => v != controller.newPasswordController.text ? 'password_mismatch'.tr : null,
                  ),
                  if (controller.failure.value != null && controller.failure.value!.validationErrors == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(controller.failure.value!.message.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
                    ),
                  const SizedBox(height: 24),
                  AppButton.primary(
                    text: 'common_save'.tr,
                    isLoading: controller.isSubmitting.value,
                    onPressed: () async {
                      if (await controller.submit()) {
                        Get.back();
                        Get.snackbar('common_success_title'.tr, 'password_saved'.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
                      }
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _error(String field) {
    final message = controller.errorFor(field);
    return message == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
          );
  }
}
