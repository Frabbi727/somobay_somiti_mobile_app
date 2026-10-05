import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_fields.dart';
import '../controller/loan_controller.dart';
import '../model/loan_account_model.dart';

class LoanRepaymentPage extends GetView<LoanRepaymentController> {
  const LoanRepaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loanCtrl = Get.find<LoanController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'ঋণের কিস্তি পরিশোধ'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ঋণ হিসাব নির্বাচন করুন', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Obx(() {
                final loans = loanCtrl.loansState.value.data ?? [];
                if (controller.selectedLoan.value == null && loans.isNotEmpty) {
                  controller.selectedLoan.value = loans.first;
                  controller.amountController.text = loans.first.installmentAmount.toStringAsFixed(0);
                }

                return DropdownButtonFormField<LoanAccountModel>(
                  value: controller.selectedLoan.value,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: loans.map((ln) {
                    return DropdownMenuItem<LoanAccountModel>(
                      value: ln,
                      child: Text('${ln.loanScheme} (${ln.loanNumber})'),
                    );
                  }).toList(),
                  onChanged: (ln) {
                    controller.selectedLoan.value = ln;
                    if (ln != null) {
                      controller.amountController.text = ln.installmentAmount.toStringAsFixed(0);
                    }
                  },
                );
              }),
              const SizedBox(height: 20),
              AppTextField(
                label: 'কিস্তির পরিমাণ (BDT)',
                controller: controller.amountController,
                validator: (val) => AppValidator.validateAmount(val, min: 100),
                keyboardType: TextInputType.number,
                isRequired: true,
                prefixIcon: const Icon(Icons.monetization_on_outlined),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'পেমেন্ট ট্রানজেকশন আইডি (TrxID) / ভাউচার নং',
                hint: 'যেমন: BKASH-9X87YW2',
                controller: controller.trxIdController,
                validator: (val) => AppValidator.validateRequired(val, fieldName: 'TrxID'),
                isRequired: true,
                prefixIcon: const Icon(Icons.receipt_long_outlined),
              ),
              const SizedBox(height: 36),
              Obx(() => AppButton.primary(
                    text: 'কিস্তি পরিশোধ নিশ্চিত করুন',
                    isLoading: controller.isSubmitting.value,
                    onPressed: controller.submitRepayment,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
