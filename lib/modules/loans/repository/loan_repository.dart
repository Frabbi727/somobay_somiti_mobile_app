import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/loan_account_model.dart';

abstract class ILoanRepository {
  Future<({Failure? failure, List<LoanAccountModel> loans})> getLoanAccounts();
  Future<({Failure? failure, bool isSuccess})> repayLoanInstallment({
    required String loanId,
    required double amount,
    required String transactionTrxId,
  });
}

class LoanRepository implements ILoanRepository {
  final ApiClient apiClient;

  LoanRepository({required this.apiClient});

  @override
  Future<({Failure? failure, List<LoanAccountModel> loans})> getLoanAccounts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return (
        failure: null,
        loans: const [
          LoanAccountModel(
            id: 'LN-01',
            loanNumber: 'LN-2024-88',
            loanScheme: 'ক্ষুদ্র ব্যবসা ঋণ স্কিম (Micro Business Loan)',
            sanctionedAmount: 50000.0,
            remainingBalance: 25000.0,
            installmentAmount: 2500.0,
            totalInstallments: 20,
            paidInstallments: 10,
            nextInstallmentDate: '15 Nov 2026',
            overdueAmount: 0.0,
          ),
        ],
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), loans: <LoanAccountModel>[]);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> repayLoanInstallment({
    required String loanId,
    required double amount,
    required String transactionTrxId,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }
}
