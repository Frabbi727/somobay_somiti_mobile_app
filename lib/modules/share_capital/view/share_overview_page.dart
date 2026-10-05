import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/extensions/number_extensions.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';

class ShareOverviewPage extends StatelessWidget {
  const ShareOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'শেয়ার মূলধন পোর্টফোলিও'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.4),
              child: Column(
                children: [
                  const Icon(Icons.pie_chart_rounded, size: 48, color: AppColors.secondaryDark),
                  const SizedBox(height: 12),
                  Text('মোট শেয়ারের পরিমাণ', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 4),
                  Text((5000.0).toCurrency(), style: AppTextStyles.amountLarge.copyWith(color: AppColors.secondaryDark)),
                  const SizedBox(height: 4),
                  Text('মোট ৫০ টি শেয়ার (প্রতিটি ১০০ ৳)', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('বাৎসরিক লভ্যাংশ ইতিহাস', style: AppTextStyles.titleMedium),
                  const Divider(height: 20),
                  _buildDividendRow('২০২৫ অর্থবছর (AGM-2025)', '৬০০.০০ ৳', 'পরিশোধিত (Paid)'),
                  const SizedBox(height: 10),
                  _buildDividendRow('২০২৪ অর্থবছর (AGM-2024)', '৫০০.০০ ৳', 'পরিশোধিত (Paid)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDividendRow(String year, String amount, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(year, style: AppTextStyles.bodyMedium),
            Text(status, style: AppTextStyles.caption.copyWith(color: AppColors.success)),
          ],
        ),
        Text(amount, style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
      ],
    );
  }
}
