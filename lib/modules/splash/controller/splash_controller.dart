import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/log_service.dart';
import '../repository/splash_repository.dart';

class SplashController extends GetxController {
  final ISplashRepository repository;
  final StorageService storageService;

  SplashController({
    required this.repository,
    required this.storageService,
  });

  @override
  void onInit() {
    super.onInit();
    _handleAppStartup();
  }

  Future<void> _handleAppStartup() async {
    try {
      // 1. Minimum Version & Force Update Check
      final versionResult = await repository.checkAppVersion();
      if (versionResult.versionData != null && versionResult.versionData!.forceUpdate) {
        Get.offAllNamed(
          AppRoutes.forceUpdate,
          arguments: versionResult.versionData,
        );
        return;
      }

      // 2. Authentication Check
      final token = await storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        LogService.i('Active session found, navigating to Dashboard', tag: 'STARTUP');
        Get.offAllNamed(AppRoutes.dashboard);
      } else {
        LogService.i('No active session, navigating to Login', tag: 'STARTUP');
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      LogService.e('Startup sequence failed', error: e, tag: 'STARTUP');
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
