import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/utils/bangla_number_util.dart';
import '../../../core/utils/snackbar_margin.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../core/widgets/app_step_indicator.dart';
import '../../../core/widgets/app_text_fields.dart';
import '../controller/registration_form_controller.dart';
import 'widgets/nominee_card.dart';

class RegistrationFormPage extends GetView<RegistrationFormController> {
  const RegistrationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'registration_title'.tr),
      body: Obx(() {
        final state = controller.loadState.value;
        if (state.isLoading || state.isInitial) return const AppLoading();
        if (state.isError) return AppErrorState(failure: state.failure, onRetry: controller.load);

        final step = controller.currentStep.value;

        return Column(
          children: [
            AppStepIndicator(labels: RegistrationFormController.stepLabels.map((key) => key.tr).toList(), current: step, onTap: controller.goTo),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: switch (step) {
                  0 => _personal(context),
                  1 => _contact(),
                  2 => _nominees(),
                  3 => _shares(),
                  _ => _review(),
                },
              ),
            ),
            _bottomBar(),
          ],
        );
      }),
    );
  }

  Widget _error(String field) {
    final message = controller.errorFor(field);
    return message == null ? const SizedBox.shrink() : Padding(padding: const EdgeInsets.only(top: 4), child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)));
  }

  Widget _personal(BuildContext context) => Form(
    key: controller.formKeys[0],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Obx(
            () => GestureDetector(
              onTap: _pickPhoto,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: controller.photoUrl.value == null ? null : NetworkImage(controller.photoUrl.value!),
                child: controller.photoUrl.value == null ? const Icon(Icons.add_a_photo) : null,
              ),
            ),
          ),
        ),
        TextButton(onPressed: _pickPhoto, child: Text('registration_photo_pick'.tr)),
        AppTextField(key: const Key('field_name_bn'), label: 'registration_name_bn'.tr, controller: controller.nameBnController, isRequired: true, validator: (v) => AppValidator.validateRequired(v)),
        _error('name_bn'),
        const SizedBox(height: 12),
        AppTextField(key: const Key('field_name_en'), label: 'registration_name_en'.tr, controller: controller.nameEnController, isRequired: true, validator: (v) => AppValidator.validateRequired(v)),
        _error('name_en'),
        const SizedBox(height: 12),
        AppTextField(label: 'registration_guardian'.tr, controller: controller.guardianController),
        _error('guardian_name'),
        const SizedBox(height: 12),
        AppTextField(
          label: 'registration_nid'.tr,
          controller: controller.nidController,
          keyboardType: TextInputType.number,
          validator: (v) => (v == null || v.trim().isEmpty) ? null : AppValidator.validateNID(v),
        ),
        _error('nid'),
        const SizedBox(height: 12),
        Obx(
          () => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('registration_dob'.tr),
            subtitle: Text(controller.dateOfBirth.value ?? '—'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final now = DateTime.now();
              final yesterday = DateTime(now.year, now.month, now.day - 1);
              final saved = DateTime.tryParse(controller.dateOfBirth.value ?? '');
              final initial = saved == null || saved.isAfter(yesterday) || saved.isBefore(DateTime(1920)) ? DateTime(1990) : saved;
              final picked = await showDatePicker(context: context, initialDate: initial, firstDate: DateTime(1920), lastDate: yesterday);
              if (picked != null) {
                controller.dateOfBirth.value = picked.toIso8601String().substring(0, 10);
              }
            },
          ),
        ),
        _error('date_of_birth'),
      ],
    ),
  );

  Widget _contact() => Form(
    key: controller.formKeys[1],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(key: const Key('field_mobile'), label: 'registration_mobile'.tr, initialValue: controller.mobile.value, readOnly: true),
        const SizedBox(height: 12),
        AppTextField(label: 'registration_email'.tr, controller: controller.emailController, keyboardType: TextInputType.emailAddress),
        _error('email'),
        const SizedBox(height: 12),
        AppTextField(label: 'registration_address'.tr, controller: controller.addressController, maxLines: 3),
        _error('address'),
      ],
    ),
  );

  Widget _nominees() => Form(
    key: controller.formKeys[2],
    child: Obx(() {
      final total = controller.nomineeTotalHundredths;
      controller.failure.value; // rebuild the cards when the server's field errors change
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < controller.nominees.length; i++)
            NomineeCard(
              index: i,
              row: controller.nominees[i],
              relations: controller.relations,
              onRemove: controller.nominees.length > 1 ? () => controller.removeNominee(i) : null,
              onShareChanged: controller.nominees.refresh,
              errorFor: (field) => controller.errorFor('nominees.$i.$field'),
            ),
          OutlinedButton.icon(onPressed: controller.addNominee, icon: const Icon(Icons.person_add), label: Text('registration_nominee_add'.tr)),
          const SizedBox(height: 8),
          Text(
            'registration_nominee_total'.trParams({'total': '${total ~/ 100}${total % 100 == 0 ? '' : '.${(total % 100).toString().padLeft(2, '0')}'}'}),
            style: AppTextStyles.titleMedium.copyWith(color: total == 10000 ? AppColors.success : AppColors.error),
          ),
          _error('nominees'),
        ],
      );
    }),
  );

  Widget _shares() => Form(
    key: controller.formKeys[3],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: 'registration_shares_requested'.tr,
          controller: controller.sharesController,
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (v) => (int.tryParse(BanglaNumberUtil.toEnglish((v ?? '').trim())) ?? 0) < 1 ? 'registration_required'.tr : null,
        ),
        const SizedBox(height: 8),
        Text('registration_shares_help'.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        _error('requested_shares'),
      ],
    ),
  );

  Widget _review() {
    Widget section(int step, String title, List<String> lines) => AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title.tr, style: AppTextStyles.titleMedium)),
              TextButton(onPressed: () => controller.goTo(step), child: Text('registration_edit'.tr)),
            ],
          ),
          for (final line in lines) Text(line, style: AppTextStyles.bodyMedium),
        ],
      ),
    );

    String relationOf(int? id) => controller.relations.firstWhereOrNull((r) => r.id == id)?.label ?? '—';

    return Column(
      children: [
        section(0, 'registration_step_personal', [
          controller.nameBnController.text,
          controller.nameEnController.text,
          if (controller.guardianController.text.isNotEmpty) controller.guardianController.text,
          if (controller.nidController.text.isNotEmpty) '${'registration_nid'.tr}: ${controller.nidController.text}',
          if (controller.dateOfBirth.value != null) '${'registration_dob'.tr}: ${controller.dateOfBirth.value}',
        ]),
        section(1, 'registration_step_contact', [controller.mobile.value, controller.emailController.text, controller.addressController.text].where((s) => s.isNotEmpty).toList()),
        section(2, 'registration_step_nominees', [for (final row in controller.nominees) '${row.nameController.text} (${relationOf(row.relationId.value)}) — ${row.shareController.text}%']),
        section(3, 'registration_step_shares', [controller.sharesController.text]),
        if (controller.failure.value != null) Text(controller.failure.value!.message.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
      ],
    );
  }

  Widget _bottomBar() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final step = controller.currentStep.value;
        final last = step == RegistrationFormController.stepLabels.length - 1;
        final busy = controller.saving.value || controller.submitting.value;
        return Row(
          children: [
            if (step > 0) ...[
              Expanded(
                child: AppButton(text: 'registration_back'.tr, variant: ButtonVariant.outlined, onPressed: busy ? null : controller.back),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: AppButton(text: last ? 'registration_submit'.tr : 'registration_next'.tr, isLoading: busy, onPressed: last ? _submit : _next),
            ),
          ],
        );
      }),
    ),
  );

  Future<void> _next() async {
    if (controller.currentStep.value == 2 && controller.nomineeTotalHundredths != 10000) {
      Get.snackbar('common_error_title'.tr, 'registration_total_not_100'.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
      return;
    }
    final step = controller.currentStep.value;
    final saved = await controller.next();
    final failure = controller.failure.value;
    if (saved || failure == null) return;
    // Field errors are shown under their fields; one with no field on this step still needs a message.
    final message = failure.validationErrors == null ? failure.message : controller.unshownValidationMessage(step);
    if (message != null) {
      Get.snackbar('common_error_title'.tr, message.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    }
  }

  Future<void> _submit() async {
    final confirmed = await AppConfirmationDialog.show(
      title: 'registration_submit_confirm_title'.tr,
      message: 'registration_submit_confirm_message'.tr,
      confirmText: 'registration_submit'.tr,
    );
    if (confirmed != true) {
      return;
    }

    if (await controller.submit()) {
      Get.back();
      Get.snackbar('common_success_title'.tr, 'registration_submitted'.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    } else if (controller.failure.value != null) {
      Get.snackbar('common_error_title'.tr, controller.failure.value!.message.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    }
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.pickFiles(type: FileType.image);
    final path = result?.files.single.path;
    if (path == null) {
      return;
    }
    final problem = await controller.attachPhoto(path);
    if (problem != null) {
      Get.snackbar('common_error_title'.tr, problem.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    }
  }
}
