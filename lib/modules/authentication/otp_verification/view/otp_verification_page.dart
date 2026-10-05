import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../repository/auth_repository.dart';

class OtpVerificationController extends GetxController {
  final IAuthRepository repository;
  OtpVerificationController({required this.repository});

  final otpController = TextEditingController();
  final isLoading = false.obs;
  String phone = '';

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments as String? ?? '';
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length < 4) return;
    isLoading.value = true;
    final result = await repository.verifyOtp(phone, otpController.text.trim());
    isLoading.value = false;

    if (result.isSuccess) {
      Get.offAllNamed(AppRoutes.login);
      Get.snackbar(
        'সফল',
        'যাচাইকরণ সফল হয়েছে। অনুগ্রহ করে লগইন করুন।',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}

class OtpVerificationPage extends StatelessWidget {
  const OtpVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpVerificationController(repository: Get.find<IAuthRepository>()));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'ওটিপি যাচাইকরণ'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('যাচাইকরণ কোড লিখুন', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            Text(
              '${controller.phone} নম্বরে ৪ ডিজিটের যাচাইকরণ কোড পাঠানো হয়েছে।',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 36),
            AppTextField(
              hint: '• • • •',
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.security_rounded),
            ),
            const SizedBox(height: 28),
            Obx(() => AppButton.primary(
                  text: 'যাচাই করুন',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.verifyOtp,
                )),
          ],
        ),
      ),
    );
  }
}
