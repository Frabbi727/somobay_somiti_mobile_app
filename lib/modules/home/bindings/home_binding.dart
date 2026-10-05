import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../repository/home_repository.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IHomeRepository>(
      () => HomeRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(repository: Get.find<IHomeRepository>()),
    );
  }
}
