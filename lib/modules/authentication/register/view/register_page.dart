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

class RegisterController extends GetxController {
  final IAuthRepository repository;
  RegisterController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final nidController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> submitApplication() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    final result = await repository.register({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'nid': nidController.text.trim(),
      'password': passwordController.text,
    });
    isLoading.value = false;

    if (result.isSuccess) {
      Get.toNamed(AppRoutes.otpVerification, arguments: phoneController.text.trim());
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    nidController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController(repository: Get.find<IAuthRepository>()));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'auth_register_now'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'সদস্যপদের জন্য আবেদন ফর্ম',
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 6),
              Text(
                'আপনার সঠিক তথ্য দিয়ে সদস্য হওয়ার প্রাথমিক আবেদন সম্পন্ন করুন',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 24),
              AppTextField(
                label: 'পূর্ণ নাম (জাতীয় পরিচয়পত্র অনুযায়ী)',
                hint: 'যেমন: মো: কামরুল হাসান',
                controller: controller.nameController,
                validator: (val) => AppValidator.validateRequired(val, fieldName: 'নাম'),
                isRequired: true,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'auth_phone_label'.tr,
                hint: 'auth_phone_hint'.tr,
                controller: controller.phoneController,
                validator: AppValidator.validatePhone,
                keyboardType: TextInputType.phone,
                isRequired: true,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'জাতীয় পরিচয়পত্র নম্বর (NID)',
                hint: '১০, ১৩ অথবা ১৭ ডিজিট',
                controller: controller.nidController,
                validator: AppValidator.validateNID,
                keyboardType: TextInputType.number,
                isRequired: true,
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'auth_password_label'.tr,
                hint: 'কমপক্ষে ৬ ডিজিটের পাসওয়ার্ড',
                controller: controller.passwordController,
                validator: AppValidator.validatePassword,
                obscureText: true,
                isRequired: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
              ),
              const SizedBox(height: 32),
              Obx(() => AppButton.primary(
                    text: 'আবেদন দাখিল করুন',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.submitApplication,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
