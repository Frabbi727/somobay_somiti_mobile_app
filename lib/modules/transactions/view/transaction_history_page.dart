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
import '../controller/transaction_controller.dart';
import '../model/transaction_model.dart';

class TransactionHistoryPage extends GetView<TransactionController> {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'passbook_title'.tr,
        showBackButton: false,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: Obx(() {
              final state = controller.transactionsState.value;

              if (state.isLoading) {
                return const AppLoading();
              }

              if (state.isError) {
                return AppErrorState(
                  failure: state.failure,
                  onRetry: controller.fetchTransactions,
                );
              }

              if (state.isEmpty || state.data == null || state.data!.isEmpty) {
                return AppEmptyState(
                  title: 'common_no_data_found'.tr,
                  message: 'কোনো লেনদেনের রেকর্ড পাওয়া যায়নি।',
                  onAction: controller.fetchTransactions,
                  actionText: 'পুনরায় চেষ্টা করুন',
                );
              }

              final transactions = state.data!;
              return RefreshIndicator(
                onRefresh: controller.fetchTransactions,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return _buildTransactionItem(tx);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildFilterChip('ALL', 'সকল'),
          const SizedBox(width: 8),
          _buildFilterChip('CREDIT', 'জমা (+)'),
          const SizedBox(width: 8),
          _buildFilterChip('DEBIT', 'উত্তোলন (-)'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String id, String label) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == id;
      return FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryContainer,
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (_) => controller.updateFilter(id),
      );
    });
  }

  Widget _buildTransactionItem(TransactionModel tx) {
    final isCredit = tx.type == TransactionType.credit;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () => Get.toNamed(AppRoutes.transactionDetails, arguments: tx),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit ? AppColors.primaryContainer : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: isCredit ? AppColors.deposit : AppColors.withdraw,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(
                  '${tx.createdAt} • ${tx.paymentMethod}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'} ${tx.amount.toCurrency()}',
                style: AppTextStyles.titleMedium.copyWith(
                  color: isCredit ? AppColors.deposit : AppColors.withdraw,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx.status,
                style: AppTextStyles.caption.copyWith(color: AppColors.success),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
