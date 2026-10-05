import 'package:get/get.dart';
import '../../../core/models/ui_state.dart';
import '../model/transaction_model.dart';
import '../repository/transaction_repository.dart';

class TransactionController extends GetxController {
  final ITransactionRepository repository;
  TransactionController({required this.repository});

  final transactionsState = UIState<List<TransactionModel>>.initial().obs;
  final selectedFilter = 'ALL'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    transactionsState.value = UIState.loading();
    final result = await repository.getTransactions(type: selectedFilter.value);

    if (result.failure != null) {
      transactionsState.value = UIState.error(result.failure!);
    } else if (result.transactions.isEmpty) {
      transactionsState.value = UIState.empty();
    } else {
      transactionsState.value = UIState.success(result.transactions);
    }
  }
}
