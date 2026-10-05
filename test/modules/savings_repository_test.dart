import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/network/api_client.dart';
import 'package:somobay_somiti_mobile_app/core/services/storage_service.dart';
import 'package:somobay_somiti_mobile_app/modules/savings_dps/repository/savings_repository.dart';
import 'package:somobay_somiti_mobile_app/core/config/app_config.dart';

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

  group('SavingsRepository Tests', () {
    test('Fetches default mock savings accounts with General and DPS accounts', () async {
      final repo = SavingsRepository(apiClient: ApiClient(storageService: StorageService()));
      final result = await repo.getSavingsAccounts();

      expect(result.failure, isNull);
      expect(result.accounts.length, greaterThan(0));
      expect(result.accounts.first.accountTitle, contains('সাধারণ সঞ্চয়'));
    });
  });
}
