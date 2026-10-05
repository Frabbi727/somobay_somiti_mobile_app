import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../repository/savings_repository.dart';
import '../controller/savings_controller.dart';

class SavingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ISavingsRepository>(
      () => SavingsRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<SavingsController>(
      () => SavingsController(repository: Get.find<ISavingsRepository>()),
    );
    Get.lazyPut<DepositController>(
      () => DepositController(repository: Get.find<ISavingsRepository>()),
    );
  }
}
