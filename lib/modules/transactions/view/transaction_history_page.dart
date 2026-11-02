import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../controller/transaction_controller.dart';
import '../model/statement_model.dart';
import 'package:somobay_somiti_mobile_app/core/utils/snackbar_margin.dart';

/// The passbook tab: the member statement (web portal "Statement") with a PDF download.
/// Opening, rows, totals and closing come from the backend; nothing is added up here.
class TransactionHistoryPage extends GetView<TransactionController> {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'statement_title'.tr,
        showBackButton: false,
        actions: [
          Obx(() => IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                tooltip: 'statement_pdf'.tr,
                onPressed: controller.openingPdf.value || !controller.statementState.value.isSuccess ? null : _openPdf,
              )),
        ],
      ),
      body: Obx(() {
        final state = controller.statementState.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError || state.data == null) return AppErrorState(failure: state.failure, onRetry: controller.fetchStatement);

        final statement = state.data!;
        return RefreshIndicator(
          onRefresh: controller.fetchStatement,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _rangeCard(context, statement),
              const SizedBox(height: 12),
              _totalsCard(statement),
              const SizedBox(height: 12),
              if (statement.rows.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('statement_no_rows'.tr, textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                )
              else
                ...statement.rows.map(_rowCard),
            ],
          ),
        );
      }),
    );
  }

  Widget _rangeCard(BuildContext context, StatementModel statement) {
    return AppCard(
      margin: EdgeInsets.zero,
      onTap: () => _pickRange(context, statement),
      child: Row(
        children: [
          const Icon(Icons.date_range_outlined, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'statement_range'.trParams({'from': ApiDateFormat.date(statement.from), 'until': ApiDateFormat.date(statement.until)}),
              style: AppTextStyles.titleMedium,
            ),
          ),
          Text('statement_change_range'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _totalsCard(StatementModel statement) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _line('statement_opening'.tr, statement.opening.display),
          _line('statement_charges'.tr, statement.totalCharges.display),
          _line('statement_paid'.tr, statement.totalPaid.display),
          const Divider(height: 16),
          _line('statement_closing'.tr, statement.closing.display, bold: true),
        ],
      ),
    );
  }

  Widget _rowCard(StatementRowModel row) {
    final isCharge = row.charge?.isPositive ?? false;
    final amount = isCharge ? row.charge : row.paid;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isCharge ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: isCharge ? AppColors.overdue : AppColors.deposit,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.description, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(ApiDateFormat.date(row.date), style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCharge ? 'statement_charge'.tr : 'statement_payment'.tr}: ${amount?.display ?? ApiDateFormat.empty}',
                style: AppTextStyles.bodyMedium.copyWith(color: isCharge ? AppColors.overdue : AppColors.deposit),
              ),
              const SizedBox(height: 2),
              Text('${'statement_balance'.tr}: ${row.balance?.display ?? ApiDateFormat.empty}', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: bold ? FontWeight.bold : null)),
        ],
      ),
    );
  }

  Future<void> _pickRange(BuildContext context, StatementModel statement) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: DateTime.tryParse(statement.from) ?? DateTime.now(),
        end: DateTime.tryParse(statement.until) ?? DateTime.now(),
      ),
    );
    if (picked != null) {
      await controller.setRange(
        picked.start.toIso8601String().substring(0, 10),
        picked.end.toIso8601String().substring(0, 10),
      );
    }
  }

  Future<void> _openPdf() async {
    final error = await controller.openPdf();
    if (error != null) {
      Get.snackbar('common_error_title'.tr, error.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    }
  }
}
