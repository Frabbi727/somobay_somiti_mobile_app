import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../model/auth_token_model.dart';
import '../model/login_request_model.dart';

abstract class IAuthRepository {
  Future<({Failure? failure, AuthTokenModel? tokens})> login(LoginRequestModel request);
  Future<({Failure? failure, bool isSuccess})> sendCode(String mobile);
  Future<({Failure? failure, bool isSuccess})> logout();

  // Not supported by the backend (docs/MEMBER_FEATURES.md). Kept only so the hidden screens compile.
  @Deprecated('No backend endpoint: members are registered and given passwords by the society office.')
  Future<({Failure? failure, bool isSuccess})> register(Map<String, dynamic> data);
  @Deprecated('No backend endpoint: the society office resets member passwords.')
  Future<({Failure? failure, bool isSuccess})> forgotPassword(String phone);
  @Deprecated('No backend endpoint: use sendCode + login with a code.')
  Future<({Failure? failure, bool isSuccess})> verifyOtp(String phone, String otp);
}

class AuthRepository implements IAuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  @override
  Future<({Failure? failure, AuthTokenModel? tokens})> login(LoginRequestModel request) async {
    try {
      final response = await apiClient.post(ApiConstants.login, data: request.toJson());
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, tokens: AuthTokenModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), tokens: null);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> sendCode(String mobile) async {
    try {
      await apiClient.post(ApiConstants.sendCode, data: {'mobile': mobile});
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
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

  static const _unsupported = (failure: NotFoundFailure(message: 'error_not_supported'), isSuccess: false);

  @override
  Future<({Failure? failure, bool isSuccess})> register(Map<String, dynamic> data) async => _unsupported;

  @override
  Future<({Failure? failure, bool isSuccess})> forgotPassword(String phone) async => _unsupported;

  @override
  Future<({Failure? failure, bool isSuccess})> verifyOtp(String phone, String otp) async => _unsupported;
}
