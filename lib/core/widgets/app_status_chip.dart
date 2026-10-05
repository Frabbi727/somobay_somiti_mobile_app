import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../models/enum_value_model.dart';

/// A status from the API (label already translated), coloured by the backend's colour name.
class AppStatusChip extends StatelessWidget {
  final EnumValueModel status;

  const AppStatusChip({super.key, required this.status});

  static Color colorOf(String? name) {
    switch (name) {
      case 'success':
        return AppColors.success;
      case 'warning':
        return AppColors.pending;
      case 'danger':
        return AppColors.error;
      case 'info':
        return AppColors.info;
      case 'primary':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorOf(status.color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
