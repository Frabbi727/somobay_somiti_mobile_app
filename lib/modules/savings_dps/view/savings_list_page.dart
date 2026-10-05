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
import '../controller/savings_controller.dart';
import '../model/savings_account_model.dart';

class SavingsListPage extends GetView<SavingsController> {
  const SavingsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'savings_title'.tr,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            onPressed: () => Get.toNamed(AppRoutes.newDeposit),
          ),
        ],
      ),
      body: Obx(() {
        final state = controller.accountsState.value;

        if (state.isLoading) {
          return const AppLoading();
        }

        if (state.isError) {
          return AppErrorState(
            failure: state.failure,
            onRetry: controller.fetchAccounts,
          );
        }

        if (state.isEmpty || state.data == null || state.data!.isEmpty) {
          return AppEmptyState(
            title: 'common_no_data_found'.tr,
            message: 'আপনার কোনো সঞ্চয় বা ডিপিএস হিসাব পাওয়া যায়নি।',
            actionText: 'টাকা জমা দিন',
            onAction: () => Get.toNamed(AppRoutes.newDeposit),
          );
        }

        final accounts = state.data!;
        return RefreshIndicator(
          onRefresh: controller.fetchAccounts,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return _buildSavingsCard(account);
            },
          ),
        );
      }),
    );
  }

  Widget _buildSavingsCard(SavingsAccountModel account) {
    final isDps = account.type == SavingsType.dps;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDps ? AppColors.secondaryContainer : AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDps ? Icons.trending_up_rounded : Icons.account_balance_wallet_rounded,
                      color: isDps ? AppColors.secondaryDark : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(account.accountTitle, style: AppTextStyles.titleMedium),
                      Text(
                        '${'savings_account_no'.tr}: ${account.accountNumber}',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  account.status,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
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
                  Text('মোট স্থিতি', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    account.balance.toCurrency(),
                    style: AppTextStyles.amountMedium.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              if (isDps && account.monthlyInstallment != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('savings_monthly_installment'.tr, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      account.monthlyInstallment!.toCurrency(),
                      style: AppTextStyles.titleMedium,
                    ),
                  ],
                ),
            ],
          ),
          if (isDps && account.totalInstallments != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (account.paidInstallments ?? 0) / account.totalInstallments!,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'পরিশোধিত: ${account.paidInstallments ?? 0}/${account.totalInstallments ?? 0} কিস্তি',
                  style: AppTextStyles.caption,
                ),
                if (account.maturityDate != null)
                  Text(
                    'মেয়াদ: ${account.maturityDate}',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
