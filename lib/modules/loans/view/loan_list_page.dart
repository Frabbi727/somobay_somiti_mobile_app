import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../controller/loan_controller.dart';
import '../model/loan_account_model.dart';

class LoanListPage extends GetView<LoanController> {
  const LoanListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'loan_title'.tr,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate_outlined, color: AppColors.primary),
            onPressed: () => Get.toNamed(AppRoutes.loanCalculator),
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.loansState.value;

        if (state.isLoading) {
          return const AppLoading();
        }

        if (state.isError) {
          return AppErrorState(
            failure: state.failure,
            onRetry: controller.fetchLoans,
          );
        }

        if (state.isEmpty || state.data == null || state.data!.isEmpty) {
          return AppEmptyState(
            title: 'common_no_data_found'.tr,
            message: 'আপনার কোনো চলতি বা সক্রিয় ঋণ নেই।',
            actionText: 'ঋণ ক্যালকুলেটর',
            onAction: () => Get.toNamed(AppRoutes.loanCalculator),
          );
        }

        final loans = state.data!;
        return RefreshIndicator(
          onRefresh: controller.fetchLoans,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              return _buildLoanCard(loans[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildLoanCard(LoanAccountModel loan) {
    final progress = loan.paidInstallments / loan.totalInstallments;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
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
                    Text(loan.loanScheme, style: AppTextStyles.titleMedium),
                    Text(
                      'ঋণ নং: ${loan.loanNumber}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  loan.status,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.secondaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('loan_remaining'.tr, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    loan.remainingBalance.toCurrency(),
                    style: AppTextStyles.amountMedium.copyWith(color: AppColors.withdraw),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('loan_amount'.tr, style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    loan.sanctionedAmount.toCurrency(),
                    style: AppTextStyles.titleMedium,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'পরিশোধিত: ${loan.paidInstallments}/${loan.totalInstallments} কিস্তি',
                style: AppTextStyles.caption,
              ),
              Text(
                'পরবর্তী কিস্তি: ${loan.nextInstallmentDate}',
                style: AppTextStyles.caption.copyWith(color: AppColors.overdue, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
