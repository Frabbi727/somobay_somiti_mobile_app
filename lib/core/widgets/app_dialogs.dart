import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_buttons.dart';

class AppConfirmationDialog {
  AppConfirmationDialog._();

  static Future<bool?> show({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) {
    return Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: isDestructive ? AppColors.error.withOpacity(0.1) : AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDestructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
                  color: isDestructive ? AppColors.error : AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppDimensions.space16),
              Text(
                title,
                style: AppTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.space24),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: cancelText ?? 'common_cancel'.tr,
                      variant: ButtonVariant.outlined,
                      height: 44,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: AppButton(
                      text: confirmText ?? 'common_confirm'.tr,
                      variant: isDestructive ? ButtonVariant.danger : ButtonVariant.primary,
                      height: 44,
                      onPressed: () => Get.back(result: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class AppForceUpdateDialog extends StatelessWidget {
  final String updateUrl;
  final String? releaseNotes;

  const AppForceUpdateDialog({
    Key? key,
    required this.updateUrl,
    this.releaseNotes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        backgroundColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.system_update_rounded, size: 56, color: AppColors.primary),
              const SizedBox(height: AppDimensions.space16),
              Text('force_update_title'.tr, style: AppTextStyles.h2),
              const SizedBox(height: AppDimensions.space8),
              Text(
                'force_update_message'.tr,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              if (releaseNotes != null && releaseNotes!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.space12),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.space12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppDimensions.radius8),
                  ),
                  child: Text(
                    releaseNotes!,
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.space24),
              AppButton.primary(
                text: 'force_update_button'.tr,
                onPressed: () async {
                  final uri = Uri.parse(updateUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
