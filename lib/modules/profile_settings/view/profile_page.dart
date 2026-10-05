import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_loading.dart';
import '../controller/profile_controller.dart';
import '../model/user_profile_model.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'profile_title'.tr,
        showBackButton: false,
      ),
      body: Obx(() {
        final state = controller.profileState.value;

        if (state.isLoading) {
          return const AppLoading();
        }

        final profile = state.data ??
            const UserProfileModel(
              id: '1',
              memberId: 'SOM-001',
              name: 'সদস্য',
              phone: '০১XXXXXXXXX',
              nid: '----------',
              address: 'বাংলাদেশ',
              nomineeName: '---',
              nomineeRelation: '---',
              joinedDate: '---',
            );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // User Card
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, size: 36, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.name, style: AppTextStyles.titleLarge),
                          const SizedBox(height: 2),
                          Text('${'dash_member_id'.tr}: ${profile.memberId}', style: AppTextStyles.caption),
                          const SizedBox(height: 2),
                          Text(profile.phone, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Settings & Info Options
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildTile(
                      icon: Icons.language_rounded,
                      title: 'profile_change_language'.tr,
                      subtitle: controller.currentLanguage.value == 'bn' ? 'বাংলা (Bangla)' : 'English',
                      onTap: () => Get.toNamed(AppRoutes.language),
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'profile_change_password'.tr,
                      onTap: () => Get.toNamed(AppRoutes.changePassword),
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.gavel_rounded,
                      title: 'profile_somiti_by_laws'.tr,
                      onTap: () => Get.toNamed(AppRoutes.somitiInfo),
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.people_outline_rounded,
                      title: 'dash_member_directory'.tr,
                      onTap: () => Get.toNamed(AppRoutes.members),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Logout Action
              AppCard(
                padding: EdgeInsets.zero,
                child: _buildTile(
                  icon: Icons.logout_rounded,
                  title: 'profile_logout'.tr,
                  color: AppColors.error,
                  onTap: () async {
                    final confirm = await AppConfirmationDialog.show(
                      title: 'auth_logout_title'.tr,
                      message: 'auth_logout_confirm'.tr,
                      confirmText: 'profile_logout'.tr,
                      isDestructive: true,
                    );
                    if (confirm == true) {
                      controller.logout();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: color ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: AppTextStyles.caption) : null,
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textHint),
      onTap: onTap,
    );
  }
}
