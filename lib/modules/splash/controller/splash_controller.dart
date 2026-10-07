import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
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
    final route = await startRoute();
    if (route == AppRoutes.login) {
      goToLogin();
    } else {
      Get.offAllNamed(route);
    }
  }

  /// The first screen: login without a usable session, otherwise the home screen for the account
  /// type. Offline, the last known account type is used, so an applicant is not sent to member screens.
  Future<String> startRoute() async {
    try {
      final info = await repository.somitiInfo();
      if (info.info != null) {
        await storageService.saveString(StorageKeys.somitiName, info.info!.name);
        await storageService.saveBool(StorageKeys.otpEnabled, info.info!.otpEnabled);
      }

      final token = await storageService.getAccessToken();
      if (token == null || token.isEmpty) {
        return AppRoutes.login;
      }

      final session = await repository.me();
      if (session.isValid) {
        final accountType = session.accountType ?? 'member';
        await storageService.saveAccountType(accountType);
        LogService.i('Session accepted, opening $accountType home', tag: 'STARTUP');
        return homeRouteFor(accountType);
      }

      if (session.failure is NetworkFailure || session.failure is TimeoutFailure) {
        final accountType = storageService.getAccountType();
        LogService.i('Offline, opening ${accountType ?? 'member'} home', tag: 'STARTUP');
        return homeRouteFor(accountType);
      }

      await storageService.clearAuthData();
      return AppRoutes.login;
    } catch (e) {
      LogService.e('Startup sequence failed', error: e, tag: 'STARTUP');
      return AppRoutes.login;
    }
  }
}
