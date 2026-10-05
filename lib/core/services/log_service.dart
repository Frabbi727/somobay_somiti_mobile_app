import 'dart:developer' as developer;
import '../config/app_config.dart';

class LogService {
  LogService._();

  static void d(String message, {String tag = 'DEBUG'}) {
    if (FlavorManager.config.enableLogging) {
      developer.log('[$tag] $message', name: 'APP_DEBUG');
    }
  }

  static void i(String message, {String tag = 'INFO'}) {
    if (FlavorManager.config.enableLogging) {
      developer.log('[$tag] $message', name: 'APP_INFO');
    }
  }

  static void w(String message, {String tag = 'WARN'}) {
    if (FlavorManager.config.enableLogging) {
      developer.log('⚠️ [$tag] $message', name: 'APP_WARN');
    }
  }

  static void e(String message, {dynamic error, StackTrace? stackTrace, String tag = 'ERROR'}) {
    developer.log(
      '❌ [$tag] $message',
      name: 'APP_ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
