import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../profile_settings/model/somiti_info_model.dart';

abstract class ISplashRepository {
  Future<({Failure? failure, SomitiInfoModel? info})> somitiInfo();

  /// Whether the stored session is still accepted, whose it is (member or applicant), and whether
  /// a member must first accept the current rules.
  Future<({Failure? failure, bool isValid, String? accountType, bool termsRequired})> me();
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
  Future<({Failure? failure, bool isValid, String? accountType, bool termsRequired})> me() async {
    try {
      final response = await apiClient.get(ApiConstants.me);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, isValid: true, accountType: (data['account_type'] as String?) ?? 'member', termsRequired: data['terms_acceptance_required'] == true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isValid: false, accountType: null, termsRequired: false);
    }
  }
}
