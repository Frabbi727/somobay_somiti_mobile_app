import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/savings_account_model.dart';

abstract class ISavingsRepository {
  Future<({Failure? failure, List<SavingsAccountModel> accounts})> getSavingsAccounts();
  Future<({Failure? failure, bool isSuccess})> makeDeposit({
    required String accountId,
    required double amount,
    required String paymentMethod,
  });
}

class SavingsRepository implements ISavingsRepository {
  final ApiClient apiClient;

  SavingsRepository({required this.apiClient});

  @override
  Future<({Failure? failure, List<SavingsAccountModel> accounts})> getSavingsAccounts() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return (
        failure: null,
        accounts: const [
          SavingsAccountModel(
            id: 'SAV-001',
            accountNumber: 'GEN-2024-101',
            accountTitle: 'সাধারণ সঞ্চয় হিসাব',
            type: SavingsType.general,
            balance: 15800.0,
          ),
          SavingsAccountModel(
            id: 'DPS-002',
            accountNumber: 'DPS-2024-502',
            accountTitle: '৫ বছর মেয়াদী ডিপিএস (DPS)',
            type: SavingsType.dps,
            balance: 30000.0,
            monthlyInstallment: 1000.0,
            totalInstallments: 60,
            paidInstallments: 30,
            maturityDate: '10 Oct 2029',
          ),
        ],
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), accounts: <SavingsAccountModel>[]);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> makeDeposit({
    required String accountId,
    required double amount,
    required String paymentMethod,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }
}
