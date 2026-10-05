import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/transaction_model.dart';

abstract class ITransactionRepository {
  Future<({Failure? failure, List<TransactionModel> transactions})> getTransactions({
    int page = 1,
    String? type,
  });
}

class TransactionRepository implements ITransactionRepository {
  final ApiClient apiClient;

  TransactionRepository({required this.apiClient});

  @override
  Future<({Failure? failure, List<TransactionModel> transactions})> getTransactions({
    int page = 1,
    String? type,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return (
        failure: null,
        transactions: const [
          TransactionModel(
            id: 'TX-101',
            transactionId: 'TXN87629318',
            title: 'ডিপিএস মাসিক কিস্তি জমা',
            amount: 1000.0,
            type: TransactionType.credit,
            createdAt: '01 Oct 2026, 10:30 AM',
            paymentMethod: 'bKash',
            accountNumber: 'DPS-2024-502',
          ),
          TransactionModel(
            id: 'TX-102',
            transactionId: 'TXN87629004',
            title: 'ক্ষুদ্র ব্যবসা ঋণ কিস্তি পরিশোধ',
            amount: 2500.0,
            type: TransactionType.credit,
            createdAt: '15 Sep 2026, 04:15 PM',
            paymentMethod: 'Nagad',
            accountNumber: 'LN-2024-88',
          ),
          TransactionModel(
            id: 'TX-103',
            transactionId: 'TXN87628811',
            title: 'সাধারণ সঞ্চয় হিসাব থেকে উত্তোলন',
            amount: 5000.0,
            type: TransactionType.debit,
            createdAt: '05 Sep 2026, 11:00 AM',
            paymentMethod: 'Cash',
            accountNumber: 'GEN-2024-101',
          ),
        ],
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), transactions: <TransactionModel>[]);
    }
  }
}
