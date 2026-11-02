import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_text_styles.dart';
import '../../model/terms_model.dart';

/// The rules and declaration in the current app language; the numbered lines keep their line breaks.
class RulesText extends StatelessWidget {
  final TermsModel terms;

  const RulesText({super.key, required this.terms});

  @override
  Widget build(BuildContext context) {
    final language = Get.locale?.languageCode ?? 'bn';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(terms.rules(language), key: const Key('rules_text'), style: AppTextStyles.bodyMedium),
        const SizedBox(height: 12),
        Text(terms.declaration(language), key: const Key('declaration_text'), style: AppTextStyles.titleMedium),
      ],
    );
  }
}
