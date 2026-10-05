import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../controller/profile_controller.dart';

class LanguageSelectionPage extends GetView<ProfileController> {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_change_language'.tr),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildLanguageCard(
              title: 'বাংলা (Bangla)',
              subtitle: 'সমিতির সকল তথ্য বাংলায় দেখুন',
              code: 'bn',
              country: 'BD',
            ),
            const SizedBox(height: 12),
            _buildLanguageCard(
              title: 'English',
              subtitle: 'View all somiti records in English',
              code: 'en',
              country: 'US',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String title,
    required String subtitle,
    required String code,
    required String country,
  }) {
    return Obx(() {
      final isSelected = controller.currentLanguage.value == code;
      return AppCard(
        border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
        backgroundColor: isSelected ? AppColors.primaryContainer.withOpacity(0.3) : AppColors.surface,
        onTap: () => controller.changeLanguage(code, country),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.translate_rounded,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 24),
          ],
        ),
      );
    });
  }
}
