import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controller/home_controller.dart';
import '../model/somiti_summary_model.dart';

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

          if (state.isError && state.data == null) {
            return AppErrorState(
              failure: state.failure,
              onRetry: controller.fetchSummary,
            );
          }

          final summary = state.data ??
              const SomitiSummaryModel(
                memberName: 'সদস্য',
                memberId: '---',
                somitiName: 'সমবায় সমিতি',
                totalSavings: 0,
                activeLoanBalance: 0,
                totalSharesCount: 0,
                totalSharesValue: 0,
              );

          return RefreshIndicator(
            onRefresh: controller.fetchSummary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card with Somiti Name & Member Info
                  _buildHeader(summary),
                  const SizedBox(height: 16),

                  // Financial Summary Cards
                  _buildFinancialSummaryCards(summary),
                  const SizedBox(height: 20),

                  // Quick Action Grid
                  _buildQuickActionGrid(),
                  const SizedBox(height: 20),

                  // Notice / Important Alert Card
                  if (summary.nextDueDate != null) _buildDueNoticeCard(summary),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(SomitiSummaryModel summary) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.somitiName,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      summary.memberName,
                      style: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
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
              '${'dash_member_id'.tr}: ${summary.memberId}',
              style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialSummaryCards(SomitiSummaryModel summary) {
    return Row(
      children: [
        Expanded(
          child: AppCard(
            backgroundColor: AppColors.primaryContainer.withOpacity(0.5),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.savings_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Text('dash_total_savings'.tr, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  summary.totalSavings.toCurrency(),
                  style: AppTextStyles.amountMedium.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppCard(
            backgroundColor: AppColors.secondaryContainer.withOpacity(0.5),
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded, color: AppColors.withdraw, size: 20),
                    const SizedBox(width: 6),
                    Text('dash_active_loans'.tr, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  summary.activeLoanBalance.toCurrency(),
                  style: AppTextStyles.amountMedium.copyWith(color: AppColors.withdraw),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('dash_quick_actions'.tr, style: AppTextStyles.titleLarge),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildActionItem(
              icon: Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              label: 'dash_deposit_money'.tr,
              onTap: () => Get.toNamed(AppRoutes.newDeposit),
            ),
            _buildActionItem(
              icon: Icons.payments_outlined,
              color: AppColors.withdraw,
              label: 'dash_pay_installment'.tr,
              onTap: () => Get.toNamed(AppRoutes.loanRepay),
            ),
            _buildActionItem(
              icon: Icons.calculate_outlined,
              color: AppColors.info,
              label: 'dash_loan_calculator'.tr,
              onTap: () => Get.toNamed(AppRoutes.loanCalculator),
            ),
            _buildActionItem(
              icon: Icons.pie_chart_outline_rounded,
              color: AppColors.secondary,
              label: 'dash_total_shares'.tr,
              onTap: () => Get.toNamed(AppRoutes.shareOverview),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radius12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDueNoticeCard(SomitiSummaryModel summary) {
    return AppCard(
      backgroundColor: Colors.amber.shade50,
      border: Border.all(color: Colors.amber.shade200),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event_note_rounded, color: Colors.amber.shade900, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'পরবর্তী কিস্তির তারিখ: ${summary.nextDueDate ?? ''}',
                  style: AppTextStyles.titleMedium.copyWith(color: Colors.amber.shade900),
                ),
                const SizedBox(height: 2),
                Text(
                  'কিস্তির পরিমাণ: ${summary.nextDueAmount?.toCurrency() ?? ''}',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.brown.shade800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
