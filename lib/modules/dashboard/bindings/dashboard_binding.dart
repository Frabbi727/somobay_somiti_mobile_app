import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../home/repository/home_repository.dart';
import '../../home/controller/home_controller.dart';
import '../../dues/repository/dues_repository.dart';
import '../../dues/controller/dues_controller.dart';
import '../../payments/repository/payments_repository.dart';
import '../../payments/controller/payments_controller.dart';
import '../../transactions/repository/transaction_repository.dart';
import '../../transactions/controller/transaction_controller.dart';
import '../../profile_settings/repository/profile_repository.dart';
import '../../profile_settings/controller/profile_controller.dart';

/// The five member tabs: Home · Dues · Payments · Passbook · Profile.
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Home
    Get.lazyPut<IHomeRepository>(() => HomeRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<HomeController>(() => HomeController(repository: Get.find<IHomeRepository>()));

    // Dues
    Get.lazyPut<IDuesRepository>(() => DuesRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<DuesController>(() => DuesController(repository: Get.find<IDuesRepository>()));

    // Payments
    Get.lazyPut<IPaymentsRepository>(() => PaymentsRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PaymentsController>(() => PaymentsController(repository: Get.find<IPaymentsRepository>()));

    // Passbook (statement)
    Get.lazyPut<ITransactionRepository>(() => TransactionRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<TransactionController>(() => TransactionController(repository: Get.find<ITransactionRepository>()));

    // Profile
    Get.lazyPut<IProfileRepository>(() => ProfileRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(
          repository: Get.find<IProfileRepository>(),
          storageService: Get.find<StorageService>(),
        ));
  }
}
