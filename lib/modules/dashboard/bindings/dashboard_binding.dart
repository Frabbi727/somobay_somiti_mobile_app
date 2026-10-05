import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../home/repository/home_repository.dart';
import '../../home/controller/home_controller.dart';
import '../../savings_dps/repository/savings_repository.dart';
import '../../savings_dps/controller/savings_controller.dart';
import '../../loans/repository/loan_repository.dart';
import '../../loans/controller/loan_controller.dart';
import '../../transactions/repository/transaction_repository.dart';
import '../../transactions/controller/transaction_controller.dart';
import '../../profile_settings/repository/profile_repository.dart';
import '../../profile_settings/controller/profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Home Dependencies
    Get.lazyPut<IHomeRepository>(() => HomeRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<HomeController>(() => HomeController(repository: Get.find<IHomeRepository>()));

    // Savings Dependencies
    Get.lazyPut<ISavingsRepository>(() => SavingsRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<SavingsController>(() => SavingsController(repository: Get.find<ISavingsRepository>()));
    Get.lazyPut<DepositController>(() => DepositController(repository: Get.find<ISavingsRepository>()));

    // Loans Dependencies
    Get.lazyPut<ILoanRepository>(() => LoanRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<LoanController>(() => LoanController(repository: Get.find<ILoanRepository>()));
    Get.lazyPut<LoanRepaymentController>(() => LoanRepaymentController(repository: Get.find<ILoanRepository>()));

    // Transactions Dependencies
    Get.lazyPut<ITransactionRepository>(() => TransactionRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<TransactionController>(() => TransactionController(repository: Get.find<ITransactionRepository>()));

    // Profile Dependencies
    Get.lazyPut<IProfileRepository>(() => ProfileRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<ProfileController>(() => ProfileController(
          repository: Get.find<IProfileRepository>(),
          storageService: Get.find<StorageService>(),
        ));
  }
}
