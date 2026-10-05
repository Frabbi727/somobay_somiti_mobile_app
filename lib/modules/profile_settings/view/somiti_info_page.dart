import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';

class SomitiInfoPage extends StatelessWidget {
  const SomitiInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'profile_somiti_by_laws'.tr),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('প্রগতি বহুমুখী সমবায় সমিতি লিঃ', style: AppTextStyles.h2),
                  const SizedBox(height: 6),
                  Text('নিবন্ধন নং: SOM-DH-2018-0921', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const Divider(height: 24),
                  _buildSection('১. সমিতির লক্ষ্য ও উদ্দেশ্য', 'সদস্যদের মধ্যে সঞ্চয়ের অভ্যাস গড়ে তোলা, পারস্পরিক আর্থিক সহযোগিতা এবং অর্থনৈতিক স্বাবলম্বিতা অর্জন।'),
                  const SizedBox(height: 14),
                  _buildSection('২. সদস্যপদের নিয়মাবলী', '১৮ বছর বা তদূর্ধ্ব যেকোনো বাংলাদেশি নাগরিক সমিতির নিয়মাবলী মেনে সদস্যপদের জন্য আবেদন করতে পারবেন।'),
                  const SizedBox(height: 14),
                  _buildSection('৩. সাধারণ সঞ্চয় ও ডিপিএস বিধিমালা', 'প্রত্যেক সদস্যকে নিয়মিত মাসিক সঞ্চয় বা ডিপিএস কিস্তি প্রতি মাসের ১০ তারিখের মধ্যে পরিশোধ করতে হবে।'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium),
        const SizedBox(height: 4),
        Text(content, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
