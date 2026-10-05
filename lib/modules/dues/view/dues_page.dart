import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_pagination_view.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../controller/dues_controller.dart';
import '../model/due_model.dart';

/// The web portal's Dues page: unpaid dues by default, filterable by status and type.
class DuesPage extends GetView<DuesController> {
  const DuesPage({super.key});

  static const _statuses = {'open': 'dues_filter_open', 'settled': 'dues_filter_settled', 'all': 'dues_filter_all'};
  static const _types = {
    null: 'dues_type_all',
    'deposit': 'dues_type_deposit',
    'service_charge': 'dues_type_service',
    'registration': 'dues_type_registration',
    'late_fee': 'dues_type_late_fee',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'dues_title'.tr, showBackButton: false),
      body: Column(
        children: [
          _filters(),
          Expanded(
            child: Obx(() {
              final list = controller.dues;
              return AppPaginationView<DueModel>(
                items: list.items.toList(),
                isLoading: list.isLoading.value,
                isLoadingMore: list.isLoadingMore.value,
                hasMore: list.hasMore,
                failure: list.failure,
                onRefresh: controller.refreshDues,
                onLoadMore: list.loadMore,
                emptyWidget: AppEmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  title: controller.status.value == 'open' ? 'dues_none_open'.tr : 'dues_none'.tr,
                ),
                itemBuilder: (context, due, index) => _dueCard(due),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _filters() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                children: _statuses.entries
                    .map((entry) => ChoiceChip(
                          label: Text(entry.value.tr),
                          selected: controller.status.value == entry.key,
                          onSelected: (_) => controller.setStatus(entry.key),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _types.entries
                      .map((entry) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(entry.value.tr),
                              selected: controller.type.value == entry.key,
                              onSelected: (_) => controller.setType(entry.key),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          )),
    );
  }

  Widget _dueCard(DueModel due) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ApiDateFormat.month(due.month), style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text(due.type.label, style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppStatusChip(status: due.status),
            ],
          ),
          const Divider(height: 20),
          _row('dues_amount'.tr, due.amount.display),
          _row('dues_paid'.tr, due.paid.display),
          _row(
            'dues_outstanding'.tr,
            due.outstanding.display,
            color: due.outstanding.isPositive ? AppColors.overdue : AppColors.success,
            bold: true,
          ),
          _row('dues_due_date'.tr, ApiDateFormat.date(due.dueDate)),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: bold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}
