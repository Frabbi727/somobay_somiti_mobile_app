import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../controller/person_form_state.dart';
import 'address_fields.dart';

/// Gender, passport and the present and permanent addresses: the same block for the member and each nominee.
class PersonFields extends StatelessWidget {
  final PersonFormState person;

  /// Keeps widget keys unique on one screen, e.g. `member` or `nominee_0`.
  final String keyPrefix;

  /// The server's message for a field of this person ('gender', 'present_upazila_id', …), or null.
  final String? Function(String field) errorFor;

  const PersonFields({super.key, required this.person, required this.keyPrefix, required this.errorFor});

  static const _genders = ['male', 'female', 'other'];

  Widget _error(String field) => Obx(() {
    final message = errorFor(field);
    return message == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
          );
  });

  Widget _gender() => FormField<String>(
    validator: (_) => person.gender.value == null ? 'registration_required'.tr : null,
    builder: (field) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${'registration_gender'.tr} *', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary, fontSize: 13)),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 8,
            children: [
              for (final gender in _genders)
                ChoiceChip(
                  key: Key('${keyPrefix}_gender_$gender'),
                  label: Text('registration_gender_$gender'.tr),
                  selected: person.gender.value == gender,
                  onSelected: (_) {
                    person.gender.value = gender;
                    field.didChange(gender);
                  },
                ),
            ],
          ),
        ),
        if (field.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(field.errorText!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _gender(),
        _error('gender'),
        const SizedBox(height: 12),
        AppTextField(
          key: Key('${keyPrefix}_passport'),
          label: 'registration_passport'.tr,
          controller: person.passportController,
          validator: (_) => person.passportValid ? null : 'registration_passport_invalid'.tr,
        ),
        _error('passport_no'),
        const SizedBox(height: 16),
        Text('registration_present_address'.tr, style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        AddressFields(state: person.present, prefix: 'present', keyPrefix: '${keyPrefix}_present', errorFor: errorFor),
        const SizedBox(height: 8),
        Obx(
          () => CheckboxListTile(
            key: Key('${keyPrefix}_same_as_present'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('registration_same_as_present'.tr),
            value: person.permanentSameAsPresent.value,
            onChanged: (checked) => person.setSameAsPresent(checked ?? false),
          ),
        ),
        Obx(() {
          if (person.permanentSameAsPresent.value) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('registration_permanent_address'.tr, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              AddressFields(state: person.permanent, prefix: 'permanent', keyPrefix: '${keyPrefix}_permanent', errorFor: errorFor),
            ],
          );
        }),
        _error('permanent_same_as_present'),
      ],
    );
  }
}
