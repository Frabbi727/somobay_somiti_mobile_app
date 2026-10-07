import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../profile_settings/repository/profile_repository.dart';
import '../controller/registration_form_controller.dart';
import '../controller/registration_status_controller.dart';
import '../repository/registration_repository.dart';

class RegistrationStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IRegistrationRepository>(() => RegistrationRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<IProfileRepository>(() => ProfileRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<RegistrationStatusController>(() => RegistrationStatusController(
          repository: Get.find<IRegistrationRepository>(),
          profileRepository: Get.find<IProfileRepository>(),
          storageService: Get.find<StorageService>(),
        ));
  }
}

class RegistrationFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IRegistrationRepository>(() => RegistrationRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<RegistrationFormController>(() => RegistrationFormController(repository: Get.find<IRegistrationRepository>()));
  }
}
