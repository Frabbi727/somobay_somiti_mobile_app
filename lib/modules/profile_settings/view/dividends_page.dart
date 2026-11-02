import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_pagination_view.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';

/// Yearly dividends, split by share-months (the web portal's Dividends page).
class DividendsPage extends GetView<DividendsController> {
  const DividendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_dividends'.tr),
      body: Obx(() {
        final list = controller.dividends;
        return AppPaginationView<DividendModel>(
          items: list.items.toList(),
          isLoading: list.isLoading.value,
          isLoadingMore: list.isLoadingMore.value,
          hasMore: list.hasMore,
          failure: list.failure,
          onRefresh: list.refresh,
          onLoadMore: list.loadMore,
          emptyWidget: AppEmptyState(icon: Icons.card_giftcard_outlined, title: 'dividends_none'.tr),
          itemBuilder: (context, dividend, index) => AppCard(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_digits(dividend.fiscalYear), style: AppTextStyles.titleMedium),
                      Text('dividends_share_months'.trParams({'count': _digits('${dividend.shareMonths}')}), style: AppTextStyles.caption),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(dividend.amount.display, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    AppStatusChip(status: dividend.status),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;
}
