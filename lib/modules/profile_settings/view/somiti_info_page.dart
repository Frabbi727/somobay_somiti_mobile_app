import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../controller/profile_controller.dart';
import 'package:somobay_somiti_mobile_app/core/widgets/app_logo.dart';

/// The society's name, registration, address and contact (`config/somiti-info`).
class SomitiInfoPage extends GetView<SomitiInfoController> {
  const SomitiInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_about_somiti'.tr),
      body: Obx(() {
        final state = controller.infoState.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError || state.data == null) return AppErrorState(failure: state.failure, onRetry: controller.fetch);

        final info = state.data!;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: info.logoUrl == null
                  ? const AppLogo(size: 88)
                  : CachedNetworkImage(imageUrl: info.logoUrl!, height: 80, errorWidget: (_, __, ___) => const AppLogo(size: 88)),
            ),
            const SizedBox(height: 12),
            Text(info.name, textAlign: TextAlign.center, style: AppTextStyles.h2),
            const SizedBox(height: 16),
            AppCard(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  if (info.registrationNo != null) _row(Icons.badge_outlined, 'somiti_registration'.tr, _digits(info.registrationNo!)),
                  if (info.address != null) _row(Icons.place_outlined, 'somiti_address'.tr, info.address!),
                  if (info.phone != null) _row(Icons.phone_outlined, 'somiti_phone'.tr, _digits(info.phone!)),
                  if (info.email != null) _row(Icons.email_outlined, 'somiti_email'.tr, info.email!),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: AppTextStyles.caption),
      subtitle: Text(value, style: AppTextStyles.bodyMedium),
    );
  }

  String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;
}
