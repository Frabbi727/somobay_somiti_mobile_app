import 'package:get/get.dart';
import '../../repository/auth_repository.dart';
import '../controller/login_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/storage_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(
      () => AuthRepository(apiClient: Get.find<ApiClient>()),
    );
    Get.lazyPut<LoginController>(
      () => LoginController(
        repository: Get.find<IAuthRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
