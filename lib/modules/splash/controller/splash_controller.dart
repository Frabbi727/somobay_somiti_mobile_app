import 'package:get/get.dart';
import '../../../app/routes/home_route.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/errors/failures.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/log_service.dart';
import '../repository/splash_repository.dart';
import '../../../app/routes/go_to_login.dart';

/// Start-up: load the society's details (name, SMS-code sign-in on/off), then check the stored
/// session with the backend. There is no app-version check (no backend support).
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
      final info = await repository.somitiInfo();
      if (info.info != null) {
        await storageService.saveString(StorageKeys.somitiName, info.info!.name);
        await storageService.saveBool(StorageKeys.otpEnabled, info.info!.otpEnabled);
      }

      final token = await storageService.getAccessToken();
      if (token == null || token.isEmpty) {
        goToLogin();
        return;
      }

      final session = await repository.me();
      if (session.isValid || session.failure is NetworkFailure || session.failure is TimeoutFailure) {
        // Offline with a session: open the app (as a member — the registration screens need the network anyway).
        LogService.i('Session accepted (or offline), opening ${session.accountType ?? 'member'} home', tag: 'STARTUP');
        Get.offAllNamed(homeRouteFor(session.accountType));
      } else {
        await storageService.clearAuthData();
        goToLogin();
      }
    } catch (e) {
      LogService.e('Startup sequence failed', error: e, tag: 'STARTUP');
      goToLogin();
    }
  }
}
