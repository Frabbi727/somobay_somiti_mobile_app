import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/pay_online_controller.dart';
import '../controller/payment_detail_controller.dart';
import '../controller/payments_controller.dart';
import '../repository/payments_repository.dart';

class PaymentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPaymentsRepository>(() => PaymentsRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PaymentsController>(() => PaymentsController(repository: Get.find<IPaymentsRepository>()));
  }
}

class PaymentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPaymentsRepository>(() => PaymentsRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PaymentDetailController>(() => PaymentDetailController(repository: Get.find<IPaymentsRepository>()));
  }
}

class PayOnlineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IPaymentsRepository>(() => PaymentsRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<PayOnlineController>(() => PayOnlineController(repository: Get.find<IPaymentsRepository>()));
  }
}
