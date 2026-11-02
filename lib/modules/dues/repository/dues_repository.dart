import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/models/api_page.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/paged_list.dart';
import '../model/due_model.dart';

abstract class IDuesRepository {
  /// [status]: open (default on the backend), all, settled, cancelled, waived. [type]: deposit,
  /// service_charge, registration, late_fee, or null for every type.
  Future<PageResult<DueModel>> getDues({int page = 1, String? status, String? type});
}

class DuesRepository implements IDuesRepository {
  final ApiClient apiClient;

  DuesRepository({required this.apiClient});

  @override
  Future<PageResult<DueModel>> getDues({int page = 1, String? status, String? type}) async {
    try {
      final response = await apiClient.get(ApiConstants.dues, queryParameters: {
        'page': page,
        if (status != null) 'status': status,
        if (type != null) 'type': type,
      });
      final parsed = ApiPage.parse(response.data, DueModel.fromJson);
      return (failure: null, items: parsed.items, meta: parsed.meta);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), items: <DueModel>[], meta: null);
    }
  }
}
