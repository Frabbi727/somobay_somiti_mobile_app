import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../repository/loan_repository.dart';
import '../controller/loan_controller.dart';

class LoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ILoanRepository>(
      () => LoanRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<LoanController>(
      () => LoanController(repository: Get.find<ILoanRepository>()),
    );
    Get.lazyPut<LoanRepaymentController>(
      () => LoanRepaymentController(repository: Get.find<ILoanRepository>()),
    );
  }
}
