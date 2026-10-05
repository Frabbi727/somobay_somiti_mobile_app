import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/models/money_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../payments/model/payment_summary_model.dart';
import '../controller/home_controller.dart';
import '../model/dashboard_summary_model.dart';

/// The member's position at a glance — the web portal's dashboard. Every figure comes from the
/// backend as is; nothing is calculated here.
class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final state = controller.summaryState.value;

          if (state.isLoading && state.data == null) {
            return const AppLoading();
          }

          if (state.isError || state.data == null) {
            return AppErrorState(
              failure: state.failure,
              onRetry: controller.fetchSummary,
            );
          }

          final summary = state.data!;

          return RefreshIndicator(
            onRefresh: controller.fetchSummary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(summary),
                  const SizedBox(height: 16),
                  _buildMoneyCards(summary),
                  const SizedBox(height: 12),
                  _buildPositionCard(summary),
                  const SizedBox(height: 20),
                  _buildRecentPayments(summary.recentPayments),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(DashboardSummaryModel summary) {
    final somitiName = Get.find<StorageService>().getString(StorageKeys.somitiName) ?? 'app_name'.tr;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      somitiName,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.member.name,
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
                tooltip: 'notifications_title'.tr,
                onPressed: () => Get.toNamed(AppRoutes.notifications),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            ),
            child: Text(
              '${'member_no'.tr}: ${_digits(summary.member.memberNo)}',
              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyCards(DashboardSummaryModel summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _moneyCard('home_savings'.tr, summary.savings, Icons.savings_rounded, AppColors.primary)),
            const SizedBox(width: 12),
            Expanded(child: _moneyCard('home_advance'.tr, summary.advance, Icons.account_balance_wallet_rounded, AppColors.secondary)),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.all(14),
          backgroundColor: summary.outstanding.isPositive ? Colors.amber.shade50 : AppColors.surface,
          child: Row(
            children: [
              Icon(
                Icons.event_note_rounded,
                color: summary.outstanding.isPositive ? AppColors.overdue : AppColors.success,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('home_outstanding'.tr, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      summary.outstanding.display,
                      style: AppTextStyles.amountMedium.copyWith(
                        color: summary.outstanding.isPositive ? AppColors.overdue : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              if (summary.payNowVisible)
                ElevatedButton.icon(
                  // The theme's full-width minimum size cannot lay out inside a Row.
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: () => Get.toNamed(AppRoutes.payOnline),
                  icon: const Icon(Icons.payments_outlined, size: 18),
                  label: Text('home_pay_now'.tr),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _moneyCard(String label, MoneyModel amount, IconData icon, Color color) {
    return AppCard(
      backgroundColor: color.withOpacity(0.08),
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(amount.display, style: AppTextStyles.amountMedium.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildPositionCard(DashboardSummaryModel summary) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _infoRow(
            Icons.verified_outlined,
            'home_paid_through'.tr,
            summary.paidThrough == null ? 'home_paid_through_none'.tr : ApiDateFormat.month(summary.paidThrough),
          ),
          if (summary.advance.isPositive && summary.advanceMonthsEstimate > 0) ...[
            const Divider(height: 20),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'home_advance_estimate'.trParams({'months': _digits('${summary.advanceMonthsEstimate}')}),
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
          const Divider(height: 20),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.shareOverview),
            child: Row(
              children: [
                Expanded(
                  child: _infoRow(
                    Icons.pie_chart_outline_rounded,
                    'home_shares'.tr,
                    'home_shares_count'.trParams({'count': _digits('${summary.shares}')}),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
        Text(value, style: AppTextStyles.titleMedium),
      ],
    );
  }

  Widget _buildRecentPayments(List<PaymentSummaryModel> payments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('home_recent_payments'.tr, style: AppTextStyles.titleLarge),
        const SizedBox(height: 10),
        if (payments.isEmpty)
          Text('home_no_payments'.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
        else
          ...payments.map(
            (payment) => AppCard(
              margin: const EdgeInsets.only(bottom: 10),
              onTap: () => Get.toNamed(AppRoutes.paymentDetail, arguments: payment.id),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(payment.method.label, style: AppTextStyles.titleMedium),
                        const SizedBox(height: 2),
                        Text(ApiDateFormat.date(payment.receivedOn), style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(payment.amount.display, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      AppStatusChip(status: payment.status),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;
}
