import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_pagination_view.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../controller/payments_controller.dart';
import '../model/payment_summary_model.dart';

/// The web portal's Payments page, with "Pay online".
class PaymentsPage extends GetView<PaymentsController> {
  const PaymentsPage({super.key});

  static const _filters = {
    null: 'payments_filter_all',
    'pending': 'payments_filter_pending',
    'approved': 'payments_filter_approved',
    'rejected': 'payments_filter_rejected',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'payments_title'.tr, showBackButton: false),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Get.toNamed(AppRoutes.payOnline);
          controller.refreshPayments();
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.phone_android_rounded),
        label: Text('payments_pay_online'.tr),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.entries
                        .map((entry) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(entry.value.tr),
                                selected: controller.status.value == entry.key,
                                onSelected: (_) => controller.setStatus(entry.key),
                              ),
                            ))
                        .toList(),
                  ),
                )),
          ),
          Expanded(
            child: Obx(() {
              final list = controller.payments;
              return AppPaginationView<PaymentSummaryModel>(
                items: list.items.toList(),
                isLoading: list.isLoading.value,
                isLoadingMore: list.isLoadingMore.value,
                hasMore: list.hasMore,
                failure: list.failure,
                onRefresh: controller.refreshPayments,
                onLoadMore: list.loadMore,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                emptyWidget: AppEmptyState(icon: Icons.receipt_long_outlined, title: 'payments_none'.tr),
                itemBuilder: (context, payment, index) => _paymentCard(payment),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _paymentCard(PaymentSummaryModel payment) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      onTap: () async {
        await Get.toNamed(AppRoutes.paymentDetail, arguments: payment.id);
        controller.refreshPayments();
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.method.label, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(
                  [ApiDateFormat.date(payment.receivedOn), if (payment.trxId != null) payment.trxId!].join(' • '),
                  style: AppTextStyles.caption,
                ),
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
    );
  }
}
