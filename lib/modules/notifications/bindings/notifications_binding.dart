import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../controller/notifications_controller.dart';
import '../repository/notifications_repository.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<INotificationsRepository>(() => NotificationsRepository(apiClient: Get.find<ApiClient>()));
    Get.lazyPut<NotificationsController>(() => NotificationsController(repository: Get.find<INotificationsRepository>()));
  }
}
