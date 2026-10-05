import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/ui_state.dart';
import '../model/loan_account_model.dart';
import '../repository/loan_repository.dart';

class LoanController extends GetxController {
  final ILoanRepository repository;
  LoanController({required this.repository});

  final loansState = UIState<List<LoanAccountModel>>.initial().obs;

  @override
  void onInit() {
    super.onInit();
    fetchLoans();
  }

  Future<void> fetchLoans() async {
    loansState.value = UIState.loading();
    final result = await repository.getLoanAccounts();

    if (result.failure != null) {
      loansState.value = UIState.error(result.failure!);
    } else if (result.loans.isEmpty) {
      loansState.value = UIState.empty();
    } else {
      loansState.value = UIState.success(result.loans);
    }
  }
}

class LoanRepaymentController extends GetxController {
  final ILoanRepository repository;
  LoanRepaymentController({required this.repository});

  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final trxIdController = TextEditingController();
  final selectedLoan = Rxn<LoanAccountModel>();
  final isSubmitting = false.obs;

  Future<void> submitRepayment() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedLoan.value == null) return;

    isSubmitting.value = true;
    final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
    final result = await repository.repayLoanInstallment(
      loanId: selectedLoan.value!.id,
      amount: amount,
      transactionTrxId: trxIdController.text.trim(),
    );
    isSubmitting.value = false;

    if (result.isSuccess) {
      Get.back();
      Get.snackbar(
        'সফল',
        'কিস্তি পরিশোধের তথ্য সফলভাবে জমা হয়েছে।',
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    trxIdController.dispose();
    super.onClose();
  }
}
