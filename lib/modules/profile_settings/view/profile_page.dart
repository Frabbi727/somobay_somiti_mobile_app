import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';

/// The member's details and nominees (read-only, as on the web portal) and the settings menu.
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_title'.tr, showBackButton: false),
      body: Obx(() {
        final state = controller.profileState.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError || state.data == null) return AppErrorState(failure: state.failure, onRetry: controller.fetchProfile);

        final profile = state.data!;
        return RefreshIndicator(
          onRefresh: controller.fetchProfile,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _details(profile),
              const SizedBox(height: 12),
              _nominees(profile.nominees),
              const SizedBox(height: 8),
              Text('profile_edit_note'.tr, style: AppTextStyles.caption),
              const SizedBox(height: 16),
              _menu(),
            ],
          ),
        );
      }),
    );
  }

  Widget _details(ProfileModel profile) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: AppTextStyles.h3),
                    Text('${'member_no'.tr}: ${_digits(profile.memberNo)}', style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppStatusChip(status: profile.status),
            ],
          ),
          const Divider(height: 24),
          _row('profile_name_bn'.tr, profile.nameBn),
          _row('profile_name_en'.tr, profile.nameEn),
          _row('profile_mobile'.tr, _digits(profile.mobile)),
          _row('profile_joined'.tr, ApiDateFormat.date(profile.joinedOn)),
        ],
      ),
    );
  }

  Widget _nominees(List<NomineeModel> nominees) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('profile_nominee_info'.tr, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          if (nominees.isEmpty)
            Text('profile_no_nominees'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))
          else
            ...nominees.map((n) => _row('${n.name} (${n.relation})', n.shareDisplay)),
        ],
      ),
    );
  }

  Widget _menu() {
    return AppCard(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _item(Icons.card_giftcard_rounded, 'profile_dividends'.tr, () => Get.toNamed(AppRoutes.dividends)),
          _item(Icons.sms_outlined, 'profile_messages'.tr, () => Get.toNamed(AppRoutes.notifications)),
          _item(Icons.account_balance_outlined, 'profile_about_somiti'.tr, () => Get.toNamed(AppRoutes.somitiInfo)),
          Obx(() => _item(
                Icons.translate_rounded,
                'profile_change_language'.tr,
                () => Get.toNamed(AppRoutes.language),
                // Each language is named in its own script, as language pickers do.
                subtitle: controller.currentLanguage.value == 'bn' ? 'বাংলা' : 'English',
              )),
          _item(Icons.lock_outline_rounded, 'profile_change_password'.tr, () => Get.toNamed(AppRoutes.changePassword)),
          _item(Icons.logout_rounded, 'profile_logout'.tr, _confirmLogout, color: AppColors.error),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await AppConfirmationDialog.show(
      title: 'auth_logout_title'.tr,
      message: 'auth_logout_confirm'.tr,
      confirmText: 'profile_logout'.tr,
      isDestructive: true,
    );
    if (confirmed == true) await controller.logout();
  }

  Widget _item(IconData icon, String title, VoidCallback onTap, {String? subtitle, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: AppTextStyles.titleMedium.copyWith(color: color)),
      subtitle: subtitle == null ? null : Text(subtitle, style: AppTextStyles.caption),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;
}
