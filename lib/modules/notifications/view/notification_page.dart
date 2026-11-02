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
import '../controller/notifications_controller.dart';
import '../model/sms_notification_model.dart';

/// The SMS messages the society sent this member (no read/unread or push in the backend).
class NotificationPage extends GetView<NotificationsController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'notifications_title'.tr),
      body: Obx(() {
        final list = controller.messages;
        return AppPaginationView<SmsNotificationModel>(
          items: list.items.toList(),
          isLoading: list.isLoading.value,
          isLoadingMore: list.isLoadingMore.value,
          hasMore: list.hasMore,
          failure: list.failure,
          onRefresh: list.refresh,
          onLoadMore: list.loadMore,
          emptyWidget: AppEmptyState(icon: Icons.sms_outlined, title: 'messages_none'.tr),
          itemBuilder: (context, message, index) => AppCard(
            margin: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(message.kind?.label ?? 'notifications_title'.tr, style: AppTextStyles.titleMedium)),
                    AppStatusChip(status: message.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(message.body, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 6),
                Text(ApiDateFormat.dateTime(message.sentAt), style: AppTextStyles.caption),
              ],
            ),
          ),
        );
      }),
    );
  }
}
