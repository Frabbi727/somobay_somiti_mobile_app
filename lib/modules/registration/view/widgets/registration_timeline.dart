import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/api_date_format.dart';
import '../../model/registration_model.dart';

/// ✓ done · ● pending · ○ waiting · ↩ returned · ✕ rejected — labels straight from the server.
class RegistrationTimeline extends StatelessWidget {
  final List<TimelineStepModel> steps;

  const RegistrationTimeline({super.key, required this.steps});

  static (IconData, Color) _look(String state) => switch (state) {
        'done' => (Icons.check_circle, AppColors.success),
        'pending' => (Icons.radio_button_checked, AppColors.pending),
        'returned' => (Icons.undo, AppColors.pending),
        'rejected' => (Icons.cancel, AppColors.error),
        _ => (Icons.radio_button_unchecked, AppColors.textSecondary),
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Icon(_look(steps[i].state).$1, color: _look(steps[i].state).$2),
                  if (i < steps.length - 1) Expanded(child: Container(width: 2, color: AppColors.textSecondary.withValues(alpha: 0.3))),
                ]),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(steps[i].label, style: AppTextStyles.titleMedium),
                      if (steps[i].actedAt != null)
                        Text(
                          [ApiDateFormat.dateTime(steps[i].actedAt!), if (steps[i].actor != null) steps[i].actor!].join(' · '),
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      if (steps[i].reason != null) Text(steps[i].reason!, style: AppTextStyles.bodyMedium),
                    ]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
