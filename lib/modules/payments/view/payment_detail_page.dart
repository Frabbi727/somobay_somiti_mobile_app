import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../controller/payment_detail_controller.dart';
import '../model/payment_detail_model.dart';

/// One payment: what it paid (by month and type), what went to advance, and its receipt.
class PaymentDetailPage extends GetView<PaymentDetailController> {
  const PaymentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'payment_detail_title'.tr),
      body: Obx(() {
        final state = controller.paymentState.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError || state.data == null) return AppErrorState(failure: state.failure, onRetry: controller.fetch);

        final payment = state.data!;
        return RefreshIndicator(
          onRefresh: controller.fetch,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _summary(payment),
              const SizedBox(height: 12),
              if (payment.allocations.isNotEmpty || payment.toAdvance.isPositive) _allocations(payment),
              if (payment.status.value == 'pending')
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('payment_pending_note'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ),
              if (payment.receiptAvailable) ...[
                const SizedBox(height: 16),
                Obx(() => ElevatedButton.icon(
                      onPressed: controller.openingReceipt.value ? null : () => _openReceipt(),
                      icon: const Icon(Icons.print_outlined),
                      label: Text('payment_receipt'.tr),
                    )),
              ],
            ],
          ),
        );
      }),
    );
  }

  Future<void> _openReceipt() async {
    final error = await controller.openReceipt();
    if (error != null) {
      Get.snackbar('common_error_title'.tr, error.tr, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16));
    }
  }

  Widget _summary(PaymentDetailModel payment) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(payment.amount.display, style: AppTextStyles.amountMedium.copyWith(color: AppColors.primary))),
              AppStatusChip(status: payment.status),
            ],
          ),
          const Divider(height: 24),
          _row('payment_method'.tr, payment.method.label),
          if (payment.trxId != null) _row('payment_trx'.tr, payment.trxId!),
          _row('payment_date'.tr, ApiDateFormat.date(payment.receivedOn)),
          if (payment.approvedAt != null) _row('payment_approved_at'.tr, ApiDateFormat.dateTime(payment.approvedAt)),
          if (payment.rejectionReason != null) _row('payment_rejection_reason'.tr, payment.rejectionReason!),
        ],
      ),
    );
  }

  Widget _allocations(PaymentDetailModel payment) {
    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('payment_allocations'.tr, style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          ...payment.allocations.map((a) => _row('${ApiDateFormat.month(a.month)} · ${a.type.label}', a.amount.display)),
          if (payment.toAdvance.isPositive) ...[
            const Divider(height: 16),
            _row('payment_to_advance'.tr, payment.toAdvance.display),
          ],
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
}
