enum Environment { development, staging, production }

class AppConfig {
  final String appName;
  final String apiBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLogging;
  final Environment environment;

  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableLogging,
    required this.environment,
  });

  bool get isProduction => environment == Environment.production;
  bool get isDevelopment => environment == Environment.development;
}

class FlavorManager {
  FlavorManager._();
  static late AppConfig _config;

  static void initialize(AppConfig config) {
    _config = config;
  }

  static AppConfig get config => _config;
}
