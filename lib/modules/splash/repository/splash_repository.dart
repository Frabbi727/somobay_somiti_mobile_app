import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../profile_settings/model/somiti_info_model.dart';

abstract class ISplashRepository {
  Future<({Failure? failure, SomitiInfoModel? info})> somitiInfo();

  /// Whether the stored session is still accepted by the backend.
  Future<({Failure? failure, bool isValid})> me();
}

class SplashRepository implements ISplashRepository {
  final ApiClient apiClient;

  SplashRepository({required this.apiClient});

  @override
  Future<({Failure? failure, SomitiInfoModel? info})> somitiInfo() async {
    try {
      final response = await apiClient.get(ApiConstants.somitiInfo);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, info: SomitiInfoModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), info: null);
    }
  }

  @override
  Future<({Failure? failure, bool isValid})> me() async {
    try {
      await apiClient.get(ApiConstants.me);
      return (failure: null, isValid: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isValid: false);
    }
  }
}
