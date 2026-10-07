import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/app_validator.dart';
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

  const NomineeCard({super.key, required this.index, required this.row, required this.relations, required this.onRemove, required this.onShareChanged});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('${'registration_nominee'.tr} ${index + 1}', style: Theme.of(context).textTheme.titleMedium)),
              if (onRemove != null) TextButton(onPressed: onRemove, child: Text('registration_nominee_remove'.tr)),
            ],
          ),
          AppTextField(label: 'registration_nominee_name'.tr, controller: row.nameController, isRequired: true, validator: (v) => AppValidator.validateRequired(v)),
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
          const SizedBox(height: 12),
          AppTextField(label: 'registration_nid'.tr, controller: row.nidController, isRequired: true, keyboardType: TextInputType.number, validator: AppValidator.validateNID),
          const SizedBox(height: 12),
          AppTextField(
            label: 'registration_mobile'.tr,
            controller: row.mobileController,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().isEmpty) ? null : AppValidator.validatePhone(v),
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'registration_nominee_share'.tr,
            controller: row.shareController,
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => percentToHundredths(v ?? '') == null ? 'registration_required'.tr : null,
            onChanged: (_) => onShareChanged(),
          ),
        ],
      ),
    );
  }
}
