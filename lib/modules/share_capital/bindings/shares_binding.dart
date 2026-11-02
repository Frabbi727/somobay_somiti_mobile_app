import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/shares_controller.dart';
import '../repository/shares_repository.dart';

class SharesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ISharesRepository>(() => SharesRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<SharesController>(() => SharesController(repository: Get.find<ISharesRepository>()));
  }
}
