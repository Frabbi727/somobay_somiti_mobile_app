import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../../constants/api_constants.dart';
import '../../services/storage_service.dart';
import '../../services/log_service.dart';
import '../../../app/routes/app_routes.dart';

/// Adds the access token and language to every request. On 401 it refreshes the token pair once
/// and retries. Errors are handled one at a time (QueuedInterceptor), so when several requests
/// expire together only the first refreshes; the rest see the new token and simply retry.
/// The backend treats a refresh token used twice as stolen, so this single-flight is required.
class AuthInterceptor extends QueuedInterceptor {
  final StorageService storageService;
  final Dio dio;

  /// Called once when the session cannot be renewed (tokens are already cleared).
  final void Function() onSessionExpired;

  static const _retriedFlag = 'auth_retried';

  AuthInterceptor({
    required this.storageService,
    required this.dio,
    void Function()? onSessionExpired,
  }) : onSessionExpired = onSessionExpired ?? (() => getx.Get.offAllNamed(AppRoutes.login));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept-Language'] = storageService.getLanguageCode();
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 || ApiConstants.noRefresh.contains(request.path) || request.extra[_retriedFlag] == true) {
      return handler.next(err);
    }

    final sentToken = (request.headers['Authorization'] as String?)?.replaceFirst('Bearer ', '');
    final currentToken = await storageService.getAccessToken();

    // Another request already refreshed while this one waited in the queue: just retry.
    final token = (currentToken != null && currentToken.isNotEmpty && currentToken != sentToken) ? currentToken : await _refresh();

    if (token == null) {
      await storageService.clearAuthData();
      onSessionExpired();
      return handler.next(err);
    }

    try {
      request.headers['Authorization'] = 'Bearer $token';
      request.extra[_retriedFlag] = true;
      return handler.resolve(await dio.fetch(request));
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  /// Exchanges the refresh token for a new pair; null when that is not possible.
  Future<String?> _refresh() async {
    final refreshToken = await storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    // A separate client: a refused refresh must not queue behind this interceptor.
    final client = Dio(BaseOptions(
      baseUrl: dio.options.baseUrl,
      connectTimeout: dio.options.connectTimeout,
      receiveTimeout: dio.options.receiveTimeout,
      headers: {'Accept': 'application/json', 'Accept-Language': storageService.getLanguageCode()},
    ))
      ..httpClientAdapter = dio.httpClientAdapter;

    try {
      final response = await client.post(ApiConstants.refreshToken, data: {'refresh_token': refreshToken});
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>?;
      final access = data?['access_token'] as String?;
      final refresh = data?['refresh_token'] as String?;

      if (access == null || refresh == null) {
        return null;
      }

      await storageService.saveTokens(access: access, refresh: refresh);
      return access;
    } catch (e) {
      LogService.e('Token refresh failed', error: e, tag: 'AUTH_INTERCEPTOR');
      return null;
    }
  }
}
