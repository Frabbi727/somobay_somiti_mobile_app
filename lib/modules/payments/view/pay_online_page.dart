import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/api_date_format.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_dialogs.dart';
import '../../../core/widgets/app_text_fields.dart';
import '../controller/pay_online_controller.dart';
import 'package:somobay_somiti_mobile_app/core/utils/snackbar_margin.dart';

/// Report a bKash/Nagad payment for staff approval (the web portal's Pay Online form). Only
/// emptiness is checked here; the backend validates everything and returns field errors.
class PayOnlinePage extends GetView<PayOnlineController> {
  const PayOnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: 'pay_title'.tr),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('pay_intro'.tr, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    Text('pay_method'.tr, style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(value: 'bkash', label: Text('pay_bkash'.tr)),
                        ButtonSegment(value: 'nagad', label: Text('pay_nagad'.tr)),
                      ],
                      selected: {controller.method.value},
                      onSelectionChanged: (selection) => controller.method.value = selection.first,
                    ),
                    _fieldError('method'),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'pay_amount'.tr,
                      hint: 'pay_amount_hint'.tr,
                      controller: controller.amountController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      isRequired: true,
                      validator: _required,
                    ),
                    _fieldError('amount'),
                    const SizedBox(height: 12),
                    AppTextField(
                      label: 'pay_trx'.tr,
                      hint: 'pay_trx_hint'.tr,
                      controller: controller.trxController,
                      isRequired: true,
                      validator: _required,
                    ),
                    _fieldError('trx_id'),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event_outlined),
                      title: Text('pay_date'.tr),
                      subtitle: Text(ApiDateFormat.date(controller.receivedOn.value)),
                      trailing: const Icon(Icons.edit_calendar_outlined),
                      onTap: () => _pickDate(context),
                    ),
                    _fieldError('received_on'),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.attach_file_rounded),
                      title: Text('pay_proof'.tr),
                      subtitle: Text(controller.compressing.value ? 'pay_proof_compressing'.tr : controller.proofName.value ?? 'pay_proof_choose'.tr),
                      trailing: controller.compressing.value
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))
                          : controller.proofPath.value != null
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  tooltip: 'pay_proof_remove'.tr,
                                  onPressed: controller.clearProof,
                                )
                              : const Icon(Icons.upload_file_rounded),
                      onTap: controller.compressing.value ? null : _pickProof,
                    ),
                    _fieldError('proof'),
                    if (controller.failure.value != null && controller.failure.value!.validationErrors == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(controller.failure.value!.message.tr, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
                      ),
                    const SizedBox(height: 24),
                    AppButton.primary(
                      text: 'pay_send'.tr,
                      isLoading: controller.sending.value,
                      isDisabled: controller.compressing.value,
                      onPressed: _confirmAndSend,
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => (value == null || value.trim().isEmpty) ? 'validation_required'.tr : null;

  Widget _fieldError(String field) {
    final message = controller.errorFor(field);
    return message == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
          );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(controller.receivedOn.value) ?? now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
    );
    if (picked != null) {
      controller.receivedOn.value = picked.toIso8601String().substring(0, 10);
    }
  }

  Future<void> _pickProof() async {
    final result = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'pdf']);
    final file = result?.files.single;
    if (file == null || file.path == null) return;

    final problem = await controller.attachProof(path: file.path!, name: file.name, size: file.size);
    if (problem != null) {
      Get.snackbar('common_error_title'.tr, problem.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    }
  }

  Future<void> _confirmAndSend() async {
    if (!controller.formKey.currentState!.validate()) return;

    // Like the portal's summary confirmation: show exactly what will be sent.
    final confirmed = await AppConfirmationDialog.show(
      title: 'pay_confirm_title'.tr,
      message: [
        '${'pay_method'.tr}: ${controller.method.value == 'bkash' ? 'pay_bkash'.tr : 'pay_nagad'.tr}',
        '${'pay_amount'.tr}: ${controller.amountController.text.trim()}',
        '${'pay_trx'.tr}: ${controller.trxController.text.trim().toUpperCase()}',
        '${'pay_date'.tr}: ${ApiDateFormat.date(controller.receivedOn.value)}',
        '${'pay_proof_short'.tr}: ${controller.proofName.value ?? 'pay_proof_none'.tr}',
      ].join('\n'),
      confirmText: 'pay_send'.tr,
    );
    if (confirmed != true) return;

    if (await controller.send()) {
      Get.back();
      Get.snackbar('common_success_title'.tr, controller.lastMessage ?? 'pay_sent'.tr, snackPosition: SnackPosition.BOTTOM, margin: snackbarMargin());
    }
  }
}
