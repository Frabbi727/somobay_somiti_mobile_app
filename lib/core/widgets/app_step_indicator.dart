import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../utils/bangla_number_util.dart';

/// "① Personal — ② Contact — …": done steps show a tick and can be tapped to go back; the current
/// step is filled; later steps are greyed out.
class AppStepIndicator extends StatelessWidget {
  final List<String> labels;
  final int current;
  final ValueChanged<int>? onTap;

  const AppStepIndicator({super.key, required this.labels, required this.current, this.onTap});

  String _number(int n) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(n) : '$n';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) Container(width: 16, height: 2, color: i <= current ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3)),
            InkWell(
              onTap: i < current && onTap != null ? () => onTap!(i) : null,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: i <= current ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.2),
                      child: i < current
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : Text(_number(i + 1), style: AppTextStyles.caption.copyWith(color: i == current ? Colors.white : AppColors.textSecondary)),
                    ),
                    const SizedBox(width: 6),
                    Text(labels[i], style: AppTextStyles.bodySmall.copyWith(fontWeight: i == current ? FontWeight.w600 : FontWeight.normal, color: i <= current ? null : AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
