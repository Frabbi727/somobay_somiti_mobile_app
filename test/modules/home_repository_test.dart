import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/modules/home/repository/home_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('reads the dashboard summary exactly as the backend sends it', () async {
    final api = FakeApi({'GET ${ApiConstants.dashboardSummary}': (r) => (200, fixture('dashboard_summary.bn'))});

    final result = await HomeRepository(apiClient: api.client()).getDashboardSummary();
    final summary = result.summary!;

    expect(result.failure, isNull);
    expect(summary.member.name, 'রহিম উদ্দিন');
    expect(summary.savings.poisha, 200000);
    expect(summary.savings.display, '৳ ২,০০০.০০');
    expect(summary.advance.poisha, 26000);
    expect(summary.outstanding.isPositive, isFalse);
    expect(summary.paidThrough, '2026-08');
    expect(summary.shares, 2);
    expect(summary.payNowVisible, isFalse);
    expect(summary.recentPayments.single.amount.poisha, 250000);
    expect(summary.recentPayments.single.status.value, 'approved');
  });
}
