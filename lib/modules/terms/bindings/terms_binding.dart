import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../../profile_settings/repository/profile_repository.dart';
import '../controller/accept_rules_controller.dart';
import '../repository/terms_repository.dart';

class AcceptRulesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITermsRepository>(() => TermsRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<IProfileRepository>(() => ProfileRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<AcceptRulesController>(
      () => AcceptRulesController(repository: Get.find<ITermsRepository>(), profileRepository: Get.find<IProfileRepository>(), storageService: Get.find<StorageService>()),
    );
  }
}

class RulesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ITermsRepository>(() => TermsRepository(apiClient: Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<RulesController>(() => RulesController(repository: Get.find<ITermsRepository>()));
  }
}
