import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/storage_service.dart';
import '../repository/profile_repository.dart';
import '../controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IProfileRepository>(
      () => ProfileRepository(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        repository: Get.find<IProfileRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
    Get.lazyPut<ChangePasswordController>(
      () => ChangePasswordController(repository: Get.find<IProfileRepository>()),
    );
    Get.lazyPut<DividendsController>(
      () => DividendsController(repository: Get.find<IProfileRepository>()),
    );
    Get.lazyPut<SomitiInfoController>(
      () => SomitiInfoController(repository: Get.find<IProfileRepository>()),
    );
  }
}
