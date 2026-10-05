import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/ui_state.dart';
import '../model/savings_account_model.dart';
import '../repository/savings_repository.dart';

class SavingsController extends GetxController {
  final ISavingsRepository repository;

  SavingsController({required this.repository});

  final accountsState = UIState<List<SavingsAccountModel>>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    accountsState.value = UIState.loading();
    final result = await repository.getSavingsAccounts();

    if (result.failure != null) {
      accountsState.value = UIState.error(result.failure!);
    } else if (result.accounts.isEmpty) {
      accountsState.value = UIState.empty();
    } else {
      accountsState.value = UIState.success(result.accounts);
    }
  }
}

class DepositController extends GetxController {
  final ISavingsRepository repository;
  DepositController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final selectedAccount = Rxn<SavingsAccountModel>();
  final selectedPaymentMethod = 'bKash'.obs;
  final isSubmitting = false.obs;

  Future<void> submitDeposit() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedAccount.value == null) {
      Get.snackbar('সতর্কতা', 'অনুগ্রহ করে হিসাব নির্বাচন করুন', backgroundColor: Colors.amber.shade800, colorText: Colors.white);
      return;
    }

    isSubmitting.value = true;
    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    final result = await repository.makeDeposit(
      accountId: selectedAccount.value!.id,
      amount: amount,
      paymentMethod: selectedPaymentMethod.value,
    );
    isSubmitting.value = false;

    if (result.isSuccess) {
      Get.back();
      Get.snackbar(
        'সফল',
        'টাকা জমা সফলভাবে সম্পন্ন হয়েছে।',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
