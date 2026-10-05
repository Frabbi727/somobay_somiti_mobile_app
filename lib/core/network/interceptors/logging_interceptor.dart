import 'package:dio/dio.dart';
import '../../services/log_service.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogService.d('🌐 [REQUEST] ${options.method} => ${options.uri}', tag: 'NETWORK');
    if (options.data != null) {
      LogService.d('📦 [BODY] ${options.data}', tag: 'NETWORK');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogService.d('✅ [RESPONSE] ${response.statusCode} <= ${response.requestOptions.uri}', tag: 'NETWORK');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogService.e('❌ [ERROR] ${err.response?.statusCode} <= ${err.requestOptions.uri} | Message: ${err.message}', tag: 'NETWORK');
    super.onError(err, handler);
  }
}
