import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/api_page.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/paged_list.dart';
import '../model/profile_model.dart';
import '../model/somiti_info_model.dart';

abstract class IProfileRepository {
  Future<({Failure? failure, ProfileModel? profile})> getProfile();
  Future<PageResult<DividendModel>> getDividends({int page = 1});
  Future<({Failure? failure, SomitiInfoModel? info})> getSomitiInfo();
  Future<({Failure? failure, String? message})> changePassword({required String current, required String password, required String confirmation});

  /// Ends this device's session on the backend (tokens are cleared by the caller regardless).
  Future<({Failure? failure, bool isSuccess})> logout();
}

class ProfileRepository implements IProfileRepository {
  final ApiClient apiClient;

  ProfileRepository({required this.apiClient});

  Map<String, dynamic> _data(dynamic body) => (body as Map<String, dynamic>)['data'] as Map<String, dynamic>;

  @override
  Future<({Failure? failure, ProfileModel? profile})> getProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.profile);
      return (failure: null, profile: ProfileModel.fromJson(_data(response.data)));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), profile: null);
    }
  }

  @override
  Future<PageResult<DividendModel>> getDividends({int page = 1}) async {
    try {
      final response = await apiClient.get(ApiConstants.dividends, queryParameters: {'page': page});
      final parsed = ApiPage.parse(response.data, DividendModel.fromJson);
      return (failure: null, items: parsed.items, meta: parsed.meta);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), items: <DividendModel>[], meta: null);
    }
  }

  @override
  Future<({Failure? failure, SomitiInfoModel? info})> getSomitiInfo() async {
    try {
      final response = await apiClient.get(ApiConstants.somitiInfo);
      return (failure: null, info: SomitiInfoModel.fromJson(_data(response.data)));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), info: null);
    }
  }

  @override
  Future<({Failure? failure, String? message})> changePassword({required String current, required String password, required String confirmation}) async {
    try {
      final response = await apiClient.post(ApiConstants.changePassword, data: {
        'current_password': current,
        'password': password,
        'password_confirmation': confirmation,
      });
      return (failure: null, message: (response.data as Map<String, dynamic>)['message'] as String?);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), message: null);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> logout() async {
    try {
      await apiClient.post(ApiConstants.logout);
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }
}
