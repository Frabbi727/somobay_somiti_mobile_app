import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../controller/registration_status_controller.dart';
import 'widgets/registration_timeline.dart';

class RegistrationStatusPage extends StatefulWidget {
  const RegistrationStatusPage({super.key});

  @override
  State<RegistrationStatusPage> createState() => _RegistrationStatusPageState();
}

class _RegistrationStatusPageState extends State<RegistrationStatusPage> {
  final controller = Get.find<RegistrationStatusController>();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final leaveFor = await controller.refresh();
    if (leaveFor != null) Get.offAllNamed(leaveFor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'registration_status_title'.tr,
        actions: [IconButton(icon: const Icon(Icons.logout), tooltip: 'registration_logout'.tr, onPressed: controller.logout)],
      ),
      body: Obx(() {
        final state = controller.state.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError || state.data == null) return AppErrorState(failure: state.failure, onRetry: _refresh);
        final registration = state.data!;

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            AppCard(
              margin: EdgeInsets.zero,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(registration.headline, style: AppTextStyles.h3)),
                  AppStatusChip(status: registration.status),
                ]),
                const SizedBox(height: 8),
                Text(registration.message, style: AppTextStyles.bodyMedium),
                if (registration.decision?.reason != null) ...[
                  const SizedBox(height: 12),
                  Text('${'registration_reason'.tr} (${registration.decision!.byRole}): ${registration.decision!.reason}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                ],
              ]),
            ),
            const SizedBox(height: 16),
            AppCard(margin: EdgeInsets.zero, child: RegistrationTimeline(steps: registration.timeline)),
            if (registration.canEdit) ...[
              const SizedBox(height: 24),
              AppButton(
                text: registration.nextAction == 'resubmit' ? 'registration_action_resubmit'.tr : 'registration_action_complete'.tr,
                onPressed: () async {
                  await Get.toNamed(AppRoutes.registrationForm);
                  _refresh();
                },
              ),
            ],
          ]),
        );
      }),
    );
  }
}
