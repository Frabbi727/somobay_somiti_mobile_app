import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/shares_overview_model.dart';

abstract class ISharesRepository {
  Future<({Failure? failure, SharesOverviewModel? overview})> getOverview();
}

class SharesRepository implements ISharesRepository {
  final ApiClient apiClient;

  SharesRepository({required this.apiClient});

  @override
  Future<({Failure? failure, SharesOverviewModel? overview})> getOverview() async {
    try {
      final response = await apiClient.get(ApiConstants.sharesOverview);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, overview: SharesOverviewModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), overview: null);
    }
  }
}
