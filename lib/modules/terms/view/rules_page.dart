import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../controller/accept_rules_controller.dart';
import 'widgets/rules_text.dart';

/// The rules the member accepted (read-only), from the profile.
class RulesPage extends GetView<RulesController> {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'terms_rules_title'.tr),
      body: Obx(() {
        final terms = controller.terms.value;
        if (controller.loading.value) return const AppLoading();
        if (terms == null) return AppErrorState(failure: controller.failure.value, onRetry: controller.load);

        final version = Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla('${terms.version}') : '${terms.version}';
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'terms_version'.tr}: $version', style: AppTextStyles.caption),
              const SizedBox(height: 12),
              RulesText(terms: terms),
            ],
          ),
        );
      }),
    );
  }
}
