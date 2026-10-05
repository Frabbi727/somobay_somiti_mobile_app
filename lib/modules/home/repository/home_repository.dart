import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../model/dashboard_summary_model.dart';

abstract class IHomeRepository {
  Future<({Failure? failure, DashboardSummaryModel? summary})> getDashboardSummary();
}

class HomeRepository implements IHomeRepository {
  final ApiClient apiClient;

  HomeRepository({required this.apiClient});

  @override
  Future<({Failure? failure, DashboardSummaryModel? summary})> getDashboardSummary() async {
    try {
      final response = await apiClient.get(ApiConstants.dashboardSummary);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, summary: DashboardSummaryModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), summary: null);
    }
  }
}
