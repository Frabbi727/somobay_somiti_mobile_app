import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/models/api_page.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/paged_list.dart';
import '../model/sms_notification_model.dart';

abstract class INotificationsRepository {
  Future<PageResult<SmsNotificationModel>> getMessages({int page = 1});
}

class NotificationsRepository implements INotificationsRepository {
  final ApiClient apiClient;

  NotificationsRepository({required this.apiClient});

  @override
  Future<PageResult<SmsNotificationModel>> getMessages({int page = 1}) async {
    try {
      final response = await apiClient.get(ApiConstants.notifications, queryParameters: {'page': page});
      final parsed = ApiPage.parse(response.data, SmsNotificationModel.fromJson);
      return (failure: null, items: parsed.items, meta: parsed.meta);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), items: <SmsNotificationModel>[], meta: null);
    }
  }
}
