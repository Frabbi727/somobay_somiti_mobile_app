import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/network_connectivity.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppNetworkBanner extends StatelessWidget {
  const AppNetworkBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NetworkConnectivityService>()) {
      return const SizedBox.shrink();
    }

    final connectivity = Get.find<NetworkConnectivityService>();
    return Obx(() {
      if (connectivity.isConnected.value) {
        return const SizedBox.shrink();
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: AppColors.error,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'error_no_internet'.tr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    });
  }
}
