import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../repository/transaction_repository.dart';
import '../controller/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITransactionRepository>(
      () => TransactionRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<TransactionController>(
      () => TransactionController(repository: Get.find<ITransactionRepository>()),
    );
  }
}
