import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_fields.dart';
import '../controller/profile_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_change_password'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              AppTextField(
                label: 'বর্তমান পাসওয়ার্ড',
                controller: controller.currentPasswordController,
                validator: AppValidator.validatePassword,
                obscureText: true,
                isRequired: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'নতুন পাসওয়ার্ড',
                controller: controller.newPasswordController,
                validator: AppValidator.validatePassword,
                obscureText: true,
                isRequired: true,
                prefixIcon: const Icon(Icons.lock_reset_rounded),
              ),
              const SizedBox(height: 32),
              Obx(() => AppButton.primary(
                    text: 'পাসওয়ার্ড পরিবর্তন করুন',
                    isLoading: controller.isSubmitting.value,
                    onPressed: controller.submit,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
