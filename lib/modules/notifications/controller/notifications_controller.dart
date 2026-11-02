import 'package:get/get.dart';
import '../../../core/utils/paged_list.dart';
import '../model/sms_notification_model.dart';
import '../repository/notifications_repository.dart';

class NotificationsController extends GetxController {
  final INotificationsRepository repository;

  NotificationsController({required this.repository});

  late final PagedList<SmsNotificationModel> messages = PagedList<SmsNotificationModel>((page) => repository.getMessages(page: page));

  @override
  void onInit() {
    super.onInit();
    messages.refresh();
  }
}
