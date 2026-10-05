import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_fields.dart';

class MemberListPage extends StatefulWidget {
  const MemberListPage({Key? key}) : super(key: key);

  @override
  State<MemberListPage> createState() => _MemberListPageState();
}

class _MemberListPageState extends State<MemberListPage> {
  final List<Map<String, String>> allMembers = [
    {'name': 'মো: রফিকুল ইসলাম', 'id': 'SOM-089', 'role': 'সাধারণ সদস্য', 'phone': '01712345678'},
    {'name': 'আব্দুল হাকিম', 'id': 'SOM-012', 'role': 'সভাপতি (President)', 'phone': '01812345678'},
    {'name': 'মোসা: খাদিজা পারভীন', 'id': 'SOM-045', 'role': 'সাধারণ সম্পাদক', 'phone': '01912345678'},
    {'name': 'মাহবুব আলম', 'id': 'SOM-102', 'role': 'ক্যাশিয়ার', 'phone': '01612345678'},
  ];

  late List<Map<String, String>> filteredMembers;

  @override
  void initState() {
    super.initState();
    filteredMembers = allMembers;
  }

  void _filter(String query) {
    setState(() {
      filteredMembers = allMembers
          .where((m) =>
              m['name']!.toLowerCase().contains(query.toLowerCase()) ||
              m['id']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'dash_member_directory'.tr),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppSearchField(
              hint: 'সদস্যের নাম বা নম্বর দিয়ে খুঁজুন...',
              onChanged: _filter,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final m = filteredMembers[index];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(
                          m['name']![0],
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['name']!, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${'dash_member_id'.tr}: ${m['id']}', style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          m['role']!,
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
