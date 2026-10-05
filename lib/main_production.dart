import 'core/config/app_config.dart';
import 'main_development.dart';

void main() async {
  await runSomitiApp(
    const AppConfig(
      appName: 'Somobay Somiti',
      apiBaseUrl: 'https://shomiti.techrealify.com',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      enableLogging: false,
      environment: Environment.production,
    ),
  );
}
