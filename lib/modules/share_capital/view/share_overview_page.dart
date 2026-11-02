import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../controller/shares_controller.dart';
import '../model/shares_overview_model.dart';

/// Shares held this month, every share change, and this month's rates from the approved plan.
class ShareOverviewPage extends GetView<SharesController> {
  const ShareOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'shares_title'.tr),
      body: Obx(() {
        final state = controller.overviewState.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError || state.data == null) return AppErrorState(failure: state.failure, onRetry: controller.fetch);

        final overview = state.data!;
        return RefreshIndicator(
          onRefresh: controller.fetch,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppCard(
                margin: EdgeInsets.zero,
                child: Row(
                  children: [
                    const Icon(Icons.pie_chart_rounded, color: AppColors.primary, size: 32),
                    const SizedBox(width: 12),
                    Expanded(child: Text('shares_current'.tr, style: AppTextStyles.bodyMedium)),
                    Text(_digits('${overview.currentShares}'), style: AppTextStyles.amountMedium.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text('shares_rates'.tr, style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              overview.rates == null
                  ? Text('shares_no_rates'.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
                  : _rates(overview.rates!),
              const SizedBox(height: 16),
              Text('shares_history'.tr, style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              ...overview.history.map(_change),
            ],
          ),
        );
      }),
    );
  }

  Widget _rates(RatesModel rates) {
    final lateFee = rates.lateFee;
    final lateFeeText = [
      lateFee.mode.value == 'fixed' ? lateFee.fixed?.display : null,
      lateFee.mode.value == 'percent' && lateFee.percent != null ? '${_digits(lateFee.percent!)}%' : null,
      lateFee.mode.value == 'none' ? lateFee.mode.label : null,
      if (lateFee.cap != null) 'rate_late_fee_cap'.trParams({'amount': lateFee.cap!.display}),
      lateFee.frequency?.label,
    ].whereType<String>().join(' · ');

    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('shares_rates_from'.trParams({'month': ApiDateFormat.month(rates.effectiveFrom)}), style: AppTextStyles.caption),
          const Divider(height: 16),
          _row('rate_share_unit'.tr, rates.shareUnit.display),
          _row('rate_service_charge'.tr, rates.serviceChargePerShare.display),
          _row('rate_registration_fee'.tr, rates.registrationFeePerShare.display),
          _row('rate_due_day'.tr, 'rate_due_day_value'.trParams({'day': _digits('${rates.dueDay}')})),
          _row('rate_grace_days'.tr, 'rate_grace_days_value'.trParams({'days': _digits('${rates.graceDays}')})),
          _row('rate_late_fee'.tr, lateFeeText),
        ],
      ),
    );
  }

  Widget _change(ShareChangeModel change) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            change.type.value == 'increase' ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
            color: change.type.value == 'increase' ? AppColors.deposit : AppColors.withdraw,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${change.type.label} ${_digits('${change.shares}')}', style: AppTextStyles.titleMedium),
                Text('shares_from'.trParams({'month': ApiDateFormat.month(change.effectiveFrom)}), style: AppTextStyles.caption),
                if (change.reason != null) Text(change.reason!, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text('shares_after'.trParams({'count': _digits('${change.sharesAfter}')}), style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
          const SizedBox(width: 12),
          Flexible(child: Text(value, style: AppTextStyles.bodyMedium, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;
}
