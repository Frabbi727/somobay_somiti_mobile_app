import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../repository/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final IAuthRepository repository;
  ForgotPasswordController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    final result = await repository.forgotPassword(phoneController.text.trim());
    isLoading.value = false;

    if (result.isSuccess) {
      Get.toNamed(AppRoutes.otpVerification, arguments: phoneController.text.trim());
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController(repository: Get.find<IAuthRepository>()));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'auth_forgot_password'.tr),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'পাসওয়ার্ড পুনরুদ্ধার করুন',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'আপনার সমিতিতে নিবন্ধিত মোবাইল নম্বর দিন। আমরা একটি ওটিপি (OTP) পাঠাব।',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: 'auth_phone_label'.tr,
                hint: 'auth_phone_hint'.tr,
                controller: controller.phoneController,
                validator: AppValidator.validatePhone,
                keyboardType: TextInputType.phone,
                isRequired: true,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: 28),
              Obx(() => AppButton.primary(
                    text: 'ওটিপি কোড পাঠান',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.sendOtp,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
