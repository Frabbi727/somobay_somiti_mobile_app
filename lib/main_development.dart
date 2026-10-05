import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/services/storage_service.dart';
import 'core/services/network_connectivity.dart';

Future<void> runSomitiApp(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set Orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Flavors
  FlavorManager.initialize(config);

  // Initialize Core Services
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  final connectivityService = await NetworkConnectivityService().init();
  Get.put<NetworkConnectivityService>(connectivityService, permanent: true);

  runApp(const SomitiApp());
}

void main() async {
  await runSomitiApp(
    const AppConfig(
      appName: 'Somiti App (Dev)',
      // Local backend: Android emulator reaches the host at 10.0.2.2; override with
      // --dart-define=API_BASE_URL=http://localhost:8002 for the iOS simulator.
      apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8002'),
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      enableLogging: true,
      environment: Environment.development,
    ),
  );
}
