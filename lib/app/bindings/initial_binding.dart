import 'package:get/get.dart';
import '../../core/network/api_client.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/network_connectivity.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage & Connectivity Services are registered prior to App runApp, but we ensure access here
    Get.lazyPut<ApiClient>(
      () => ApiClient(storageService: Get.find<StorageService>()),
      fenix: true,
    );
  }
}
