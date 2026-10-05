import 'package:get/get.dart';
import '../repository/splash_repository.dart';
import '../controller/splash_controller.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ISplashRepository>(
      () => SplashRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<SplashController>(
      () => SplashController(
        repository: Get.find<ISplashRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
