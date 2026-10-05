@Tags(['live'])
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/network/api_client.dart';
import 'package:somobay_somiti_mobile_app/modules/authentication/model/login_request_model.dart';
import 'package:somobay_somiti_mobile_app/modules/authentication/repository/auth_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/dues/repository/dues_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/home/repository/home_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/notifications/repository/notifications_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/repository/payments_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/profile_settings/repository/profile_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/share_capital/repository/shares_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/splash/repository/splash_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/transactions/repository/transaction_repository.dart';

/// Contract check against a running backend: every repository parses what the real API sends.
/// Read-only apart from signing in and out. Run with:
///   LIVE_API_URL=http://127.0.0.1:8002 flutter test test/live --tags live
/// using a member from the demo data (docs: backend docs/LOCAL_TESTING.md).
void main() {
  final baseUrl = Platform.environment['LIVE_API_URL'];
  final members = {'01711000003': 'Salma (advance)', '01711000004': 'Jamal (late fees)'};

  for (final entry in members.entries) {
    test('the app reads ${entry.value}\'s data from the live backend', () async {
      String? token;
      ApiClient client(String language) => ApiClient.forTesting(Dio(BaseOptions(
            baseUrl: baseUrl!,
            headers: {
              'Accept': 'application/json',
              'Accept-Language': language,
              if (token != null) 'Authorization': 'Bearer $token',
            },
          )));

      final info = await SplashRepository(apiClient: client('bn')).somitiInfo();
      expect(info.failure, isNull, reason: 'somiti-info');

      final login = await AuthRepository(apiClient: client('bn')).login(LoginRequestModel(mobile: entry.key, password: 'password'));
      expect(login.failure, isNull, reason: 'login: ${login.failure?.message}');
      token = login.tokens!.accessToken;

      for (final language in ['bn', 'en']) {
        final api = client(language);

        expect((await SplashRepository(apiClient: api).me()).isValid, isTrue, reason: 'me');

        final home = await HomeRepository(apiClient: api).getDashboardSummary();
        expect(home.failure, isNull, reason: 'dashboard ${home.failure?.message}');

        final dues = await DuesRepository(apiClient: api).getDues(status: 'all');
        expect(dues.failure, isNull, reason: 'dues ${dues.failure?.message}');

        final payments = await PaymentsRepository(apiClient: api).getPayments();
        expect(payments.failure, isNull, reason: 'payments ${payments.failure?.message}');
        for (final payment in payments.items.take(3)) {
          final detail = await PaymentsRepository(apiClient: api).getPayment(payment.id);
          expect(detail.failure, isNull, reason: 'payment ${payment.id}');
          final allocated = detail.payment!.allocations.fold<int>(0, (sum, a) => sum + a.amount.poisha);
          if (detail.payment!.status.value == 'approved') {
            expect(allocated + detail.payment!.toAdvance.poisha, detail.payment!.amount.poisha, reason: 'allocation invariant ${payment.id}');
          }
        }

        final statement = await TransactionRepository(apiClient: api).getStatement();
        expect(statement.failure, isNull, reason: 'statement ${statement.failure?.message}');
        expect((await TransactionRepository(apiClient: api).statementPdfUrl()).url, isNotNull, reason: 'statement pdf link');

        expect((await SharesRepository(apiClient: api).getOverview()).failure, isNull, reason: 'shares');
        expect((await NotificationsRepository(apiClient: api).getMessages()).failure, isNull, reason: 'messages');
        expect((await ProfileRepository(apiClient: api).getProfile()).failure, isNull, reason: 'profile');
        expect((await ProfileRepository(apiClient: api).getDividends()).failure, isNull, reason: 'dividends');

        // ignore: avoid_print
        print('${entry.value} [$language]: savings ${home.summary!.savings.display}, advance ${home.summary!.advance.display}, '
            'outstanding ${home.summary!.outstanding.display}, paid through ${home.summary!.paidThrough}, '
            'dues ${dues.items.length}/${dues.meta?.total}, payments ${payments.items.length}, statement rows ${statement.statement!.rows.length}');
      }

      expect((await ProfileRepository(apiClient: client('bn')).logout()).isSuccess, isTrue, reason: 'logout');
    }, skip: baseUrl == null ? 'Set LIVE_API_URL to run against a backend' : false);
  }
}
