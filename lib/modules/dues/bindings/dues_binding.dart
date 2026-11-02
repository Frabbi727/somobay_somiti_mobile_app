import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/dues_controller.dart';
import '../repository/dues_repository.dart';

class DuesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IDuesRepository>(() => DuesRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<DuesController>(() => DuesController(repository: Get.find<IDuesRepository>()));
  }
}
