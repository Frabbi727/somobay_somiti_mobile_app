import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'বার্ষিক সাধারণ সভা (AGM-2026) সংক্রান্ত নোটিশ',
        'desc': 'আগামী ২৫ নভেম্বর ২০২৬ তারিখ সমিতির বার্ষিক সাধারণ সভা অনুষ্ঠিত হবে। সকল সদস্যের উপস্থিতি কামনা করা হচ্ছে।',
        'time': '০৪ অক্টোবর ২০২৬',
        'isUnread': true,
      },
      {
        'title': 'মাসিক ডিপিএস কিস্তি জমার স্মারক',
        'desc': 'আপনার অক্টোবর মাসের ডিপিএস কিস্তি ১০ তারিখের মধ্যে পরিশোধ করার জন্য অনুরোধ করা হচ্ছে।',
        'time': '০১ অক্টোবর ২০২৬',
        'isUnread': false,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'dash_notices'.tr),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          final isUnread = n['isUnread'] as bool;

          return AppCard(
            margin: const EdgeInsets.only(bottom: 12),
            backgroundColor: isUnread ? AppColors.primaryContainer.withOpacity(0.2) : AppColors.surface,
            border: isUnread ? Border.all(color: AppColors.primaryLight.withOpacity(0.5)) : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        n['title'] as String,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isUnread ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  n['desc'] as String,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),
                Text(
                  n['time'] as String,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
