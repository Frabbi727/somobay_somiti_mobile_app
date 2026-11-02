import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../controller/accept_rules_controller.dart';
import 'widgets/rules_text.dart';

/// Shown to a member until they accept the current rules; nothing else in the app opens before that.
class AcceptRulesPage extends GetView<AcceptRulesController> {
  const AcceptRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppAppBar(
          title: 'terms_accept_title'.tr,
          showBackButton: false,
          actions: [TextButton(onPressed: controller.logout, child: Text('profile_logout'.tr))],
        ),
        body: Obx(() {
          final terms = controller.terms.value;
          if (controller.loading.value && terms == null) return const AppLoading();
          if (terms == null) return AppErrorState(failure: controller.failure.value, onRetry: controller.load);

          final language = Get.locale?.languageCode ?? 'bn';
          final version = language == 'bn' ? BanglaNumberUtil.toBangla('${terms.version}') : '${terms.version}';
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${'terms_version'.tr}: $version', style: AppTextStyles.caption),
                      const SizedBox(height: 8),
                      Text('terms_accept_intro'.tr, style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 12),
                      RulesText(terms: terms),
                      if (controller.failure.value != null) ...[
                        const SizedBox(height: 12),
                        Text(controller.failure.value!.message.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                      ],
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        key: const Key('terms_checkbox'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: controller.agreed.value,
                        onChanged: controller.accepting.value ? null : (value) => controller.agreed.value = value ?? false,
                        title: Text('terms_agree'.tr),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AppButton(text: 'terms_accept_button'.tr, isLoading: controller.accepting.value, onPressed: controller.agreed.value ? _accept : null),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _accept() async {
    // A failure is shown inline above the button, so no snackbar repeats it.
    await controller.accept();
  }
}
