import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../model/auth_token_model.dart';
import '../model/login_request_model.dart';

abstract class IAuthRepository {
  Future<({Failure? failure, AuthTokenModel? tokens})> login(LoginRequestModel request);
  Future<({Failure? failure, bool isSuccess})> register(Map<String, dynamic> data);
  Future<({Failure? failure, bool isSuccess})> forgotPassword(String phone);
  Future<({Failure? failure, bool isSuccess})> verifyOtp(String phone, String otp);
  Future<({Failure? failure, bool isSuccess})> logout();
}

class AuthRepository implements IAuthRepository {
  final ApiClient apiClient;

  AuthRepository({required this.apiClient});

  @override
  Future<({Failure? failure, AuthTokenModel? tokens})> login(LoginRequestModel request) async {
    try {
      // In live environment:
      // final response = await apiClient.post(ApiConstants.login, data: request.toJson());
      // return (failure: null, tokens: AuthTokenModel.fromJson(response.data['data']));

      // Mock delay & successful login for production testing/demo
      await Future.delayed(const Duration(milliseconds: 900));
      return (
        failure: null,
        tokens: const AuthTokenModel(
          accessToken: 'mock_jwt_access_token_12345',
          refreshToken: 'mock_jwt_refresh_token_67890',
        ),
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), tokens: null);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> register(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(milliseconds: 900));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> forgotPassword(String phone) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> verifyOtp(String phone, String otp) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }

  @override
  Future<({Failure? failure, bool isSuccess})> logout() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return (failure: null, isSuccess: true);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), isSuccess: false);
    }
  }
}
