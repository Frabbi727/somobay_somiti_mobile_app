import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/bangla_number_util.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../controller/nominee_form_row.dart';
import '../../controller/registration_form_controller.dart';
import '../../model/registration_model.dart';

class NomineeCard extends StatelessWidget {
  final int index;
  final NomineeFormRow row;
  final List<NomineeRelationModel> relations;
  final VoidCallback? onRemove;
  final VoidCallback onShareChanged;

  /// The server's message for one of this nominee's fields ('name', 'relation_id', …), or null.
  final String? Function(String field) errorFor;

  const NomineeCard({
    super.key,
    required this.index,
    required this.row,
    required this.relations,
    required this.onRemove,
    required this.onShareChanged,
    required this.errorFor,
  });

  static String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;

  Widget _error(String field) {
    final message = errorFor(field);
    return message == null ? const SizedBox.shrink() : Padding(padding: const EdgeInsets.only(top: 4), child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)));
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('${'registration_nominee'.tr} ${_digits('${index + 1}')}', style: Theme.of(context).textTheme.titleMedium)),
              if (onRemove != null) TextButton(onPressed: onRemove, child: Text('registration_nominee_remove'.tr)),
            ],
          ),
          AppTextField(label: 'registration_nominee_name'.tr, controller: row.nameController, isRequired: true, validator: (v) => AppValidator.validateRequired(v)),
          _error('name'),
          const SizedBox(height: 12),
          Obx(
            () => DropdownButtonFormField<int>(
              initialValue: row.relationId.value,
              decoration: InputDecoration(labelText: 'registration_nominee_relation'.tr),
              items: [for (final relation in relations) DropdownMenuItem(value: relation.id, child: Text(relation.label))],
              onChanged: (value) => row.relationId.value = value,
              validator: (value) => value == null ? 'registration_required'.tr : null,
            ),
          ),
          _error('relation_id'),
          const SizedBox(height: 12),
          AppTextField(label: 'registration_nid'.tr, controller: row.nidController, isRequired: true, keyboardType: TextInputType.number, validator: AppValidator.validateNID),
          _error('nid'),
          const SizedBox(height: 12),
          AppTextField(
            label: 'registration_nominee_mobile'.tr,
            controller: row.mobileController,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().isEmpty) ? null : AppValidator.validatePhone(v),
          ),
          _error('mobile'),
          const SizedBox(height: 12),
          AppTextField(
            label: 'registration_nominee_share'.tr,
            controller: row.shareController,
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => percentToHundredths(v ?? '') == null ? 'registration_required'.tr : null,
            onChanged: (_) => onShareChanged(),
          ),
          _error('share_percent'),
        ],
      ),
    );
  }
}
