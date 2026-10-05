import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/app_validator.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/app_text_fields.dart';
import '../controller/savings_controller.dart';
import '../model/savings_account_model.dart';

class NewDepositPage extends GetView<DepositController> {
  const NewDepositPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final savingsCtrl = Get.find<SavingsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'টাকা জমা প্রদান'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('জমার হিসাব নির্বাচন করুন', style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              Obx(() {
                final accounts = savingsCtrl.accountsState.value.data ?? [];
                if (controller.selectedAccount.value == null && accounts.isNotEmpty) {
                  controller.selectedAccount.value = accounts.first;
                }

                return DropdownButtonFormField<SavingsAccountModel>(
                  value: controller.selectedAccount.value,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: accounts.map((acc) {
                    return DropdownMenuItem<SavingsAccountModel>(
                      value: acc,
                      child: Text('${acc.accountTitle} (${acc.accountNumber})'),
                    );
                  }).toList(),
                  onChanged: (acc) => controller.selectedAccount.value = acc,
                );
              }),
              const SizedBox(height: 20),
              AppTextField(
                label: 'টাকার পরিমাণ (BDT)',
                hint: 'যেমন: ১০০০',
                controller: controller.amountController,
                validator: (val) => AppValidator.validateAmount(val, min: 100),
                keyboardType: TextInputType.number,
                isRequired: true,
                prefixIcon: const Icon(Icons.monetization_on_outlined),
              ),
              const SizedBox(height: 24),
              Text('পেমেন্ট মাধ্যম', style: AppTextStyles.titleMedium),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildPaymentMethodChip('bKash', 'বিকাশ'),
                  const SizedBox(width: 12),
                  _buildPaymentMethodChip('Nagad', 'নগদ'),
                  const SizedBox(width: 12),
                  _buildPaymentMethodChip('Bank', 'ব্যাংক / ক্যাশ'),
                ],
              ),
              const SizedBox(height: 36),
              Obx(() => AppButton.primary(
                    text: 'জমা নিশ্চিত করুন',
                    isLoading: controller.isSubmitting.value,
                    onPressed: controller.submitDeposit,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodChip(String id, String label) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == id;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primaryContainer,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) controller.selectedPaymentMethod.value = id;
        },
      );
    });
  }
}
