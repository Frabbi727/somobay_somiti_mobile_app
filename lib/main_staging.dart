import 'core/config/app_config.dart';
import 'main_development.dart';

void main() async {
  await runSomitiApp(
    const AppConfig(
      appName: 'Somiti App (Staging)',
      apiBaseUrl: 'https://shomiti.techrealify.com',
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      enableLogging: true,
      environment: Environment.staging,
    ),
  );
}
