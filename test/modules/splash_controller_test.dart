import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/app/routes/app_routes.dart';
import 'package:somobay_somiti_mobile_app/core/config/app_config.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/profile_settings/model/somiti_info_model.dart';
import 'package:somobay_somiti_mobile_app/modules/splash/controller/splash_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/splash/repository/splash_repository.dart';

import '../core/auth_interceptor_test.dart' show MemoryStorage;

class FakeSplashRepository implements ISplashRepository {
  final ({Failure? failure, bool isValid, String? accountType}) session;

  FakeSplashRepository(this.session);

  @override
  Future<({Failure? failure, SomitiInfoModel? info})> somitiInfo() async => (failure: const NetworkFailure(), info: null);

  @override
  Future<({Failure? failure, bool isValid, String? accountType})> me() async => session;
}

void main() {
  setUp(() {
    FlavorManager.initialize(
      const AppConfig(
        appName: 'Test App',
        apiBaseUrl: 'https://test.api.com',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        enableLogging: false,
        environment: Environment.development,
      ),
    );
  });

  test('offline, an applicant opens on the registration status, not the member dashboard', () async {
    final storage = MemoryStorage(access: 'a', refresh: 'r', accountType: 'applicant');
    final controller = SplashController(repository: FakeSplashRepository((failure: const NetworkFailure(), isValid: false, accountType: null)), storageService: storage);

    expect(await controller.startRoute(), AppRoutes.registration);
  });

  test('offline with no remembered account type opens the dashboard', () async {
    final storage = MemoryStorage(access: 'a', refresh: 'r');
    final controller = SplashController(repository: FakeSplashRepository((failure: const TimeoutFailure(), isValid: false, accountType: null)), storageService: storage);

    expect(await controller.startRoute(), AppRoutes.dashboard);
  });

  test('online, remembers the account type auth/me returns', () async {
    final storage = MemoryStorage(access: 'a', refresh: 'r', accountType: 'applicant');
    final controller = SplashController(repository: FakeSplashRepository((failure: null, isValid: true, accountType: 'member')), storageService: storage);

    expect(await controller.startRoute(), AppRoutes.dashboard);
    expect(storage.accountType, 'member');
  });

  test('a refused session clears the remembered account type and goes to login', () async {
    final storage = MemoryStorage(access: 'a', refresh: 'r', accountType: 'applicant');
    final controller = SplashController(repository: FakeSplashRepository((failure: const AuthenticationFailure(), isValid: false, accountType: null)), storageService: storage);

    expect(await controller.startRoute(), AppRoutes.login);
    expect(storage.accountType, isNull);
  });
}
