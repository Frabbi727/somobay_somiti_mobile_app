import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../services/storage_service.dart';
import '../../services/log_service.dart';
import '../../../app/routes/app_routes.dart';

class AuthInterceptor extends QueuedInterceptor {
  final StorageService storageService;
  final Dio dio;

  AuthInterceptor({
    required this.storageService,
    required this.dio,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final langCode = storageService.getLanguageCode();
    options.headers['Accept-Language'] = langCode;
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      LogService.w('401 Unauthorized detected - attempting token refresh', tag: 'AUTH_INTERCEPTOR');
      final refreshToken = await storageService.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Attempt token refresh
          final response = await dio.post(
            '/api/v1/auth/refresh-token',
            data: {'refresh_token': refreshToken},
            options: Options(headers: {'RequiresToken': false}),
          );

          if (response.statusCode == 200 && response.data != null) {
            final newAccessToken = response.data['data']?['access_token'];
            final newRefreshToken = response.data['data']?['refresh_token'] ?? refreshToken;

            if (newAccessToken != null) {
              await storageService.saveTokens(
                access: newAccessToken,
                refresh: newRefreshToken,
              );

              // Retry original request with new token
              final reqOptions = err.requestOptions;
              reqOptions.headers['Authorization'] = 'Bearer $newAccessToken';

              final retryResponse = await dio.fetch(reqOptions);
              return handler.resolve(retryResponse);
            }
          }
        } catch (refreshErr) {
          LogService.e('Token refresh failed', error: refreshErr, tag: 'AUTH_INTERCEPTOR');
        }
      }

      // If refresh fails or no token, clean up and redirect to login
      await storageService.clearAuthData();
      getx.Get.offAllNamed(AppRoutes.login);
    }

    handler.next(err);
  }
}
