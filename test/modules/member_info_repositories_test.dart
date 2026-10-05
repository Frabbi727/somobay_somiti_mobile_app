import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/notifications/repository/notifications_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/profile_settings/repository/profile_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/share_capital/repository/shares_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('shares: current shares, history and this month\'s rates', () async {
    final api = FakeApi({'GET ${ApiConstants.sharesOverview}': (r) => (200, fixture('shares_overview.en'))});

    final shares = (await SharesRepository(apiClient: api.client()).getOverview()).overview!;

    expect(shares.currentShares, 2);
    expect(shares.history.single.sharesAfter, 2);
    expect(shares.history.single.effectiveFrom, '2026-07');
    expect(shares.rates?.shareUnit.poisha, 50000);
    expect(shares.rates?.lateFee.mode.value, 'none');
    expect(shares.rates?.lateFee.percent, isNull);
  });

  test('shares: no rates when no plan covers this month', () async {
    final body = fixture('shares_overview.en');
    (body['data'] as Map<String, dynamic>)['rates'] = null;
    final api = FakeApi({'GET ${ApiConstants.sharesOverview}': (r) => (200, body)});

    expect((await SharesRepository(apiClient: api.client()).getOverview()).overview?.rates, isNull);
  });

  test('messages: the SMS history page', () async {
    final api = FakeApi({'GET ${ApiConstants.notifications}': (r) => (200, fixture('notifications.en'))});

    final page = await NotificationsRepository(apiClient: api.client()).getMessages(page: 1);

    expect(page.items.first.kind?.value, 'payment_approved');
    expect(page.items.first.body, contains('৳'));
    expect(page.items.first.sentAt, '2026-08-12T10:00:00+06:00');
  });

  test('profile, nominees and dividends', () async {
    final api = FakeApi({
      'GET ${ApiConstants.profile}': (r) => (200, fixture('profile.en')),
      'GET ${ApiConstants.dividends}': (r) => (200, envelope([
            {'id': 7, 'fiscal_year': '2026-27', 'share_months': 24, 'amount': money(123456, '৳ 1,234.56'), 'status': enumValue('credited'), 'settled_at': null},
          ], meta: {'current_page': 1, 'last_page': 1, 'per_page': 20, 'total': 1})),
    });
    final repository = ProfileRepository(apiClient: api.client());

    final profile = (await repository.getProfile()).profile!;
    expect(profile.nameBn, 'রহিম উদ্দিন');
    expect(profile.joinedOn, '2026-07-01');
    expect(profile.nominees.single.sharePercent, '100.00');

    final dividends = await repository.getDividends(page: 1);
    expect(dividends.items.single.amount.display, '৳ 1,234.56');
    expect(dividends.items.single.shareMonths, 24);
  });

  test('change password sends the confirmation and surfaces field errors', () async {
    final api = FakeApi({
      'POST ${ApiConstants.changePassword}': (r) => (r.data as Map)['current_password'] == 'right'
          ? (200, envelope(null, message: 'saved'))
          : (422, envelopeError(422, 'wrong current password')),
    });
    final repository = ProfileRepository(apiClient: api.client());

    final ok = await repository.changePassword(current: 'right', password: 'new-pass-2', confirmation: 'new-pass-2');
    expect(ok.failure, isNull);
    expect(api.last.data, {'current_password': 'right', 'password': 'new-pass-2', 'password_confirmation': 'new-pass-2'});

    final wrong = await repository.changePassword(current: 'nope', password: 'new-pass-2', confirmation: 'new-pass-2');
    expect(wrong.failure, isA<ValidationFailure>());
    expect(wrong.failure?.message, 'wrong current password');
  });
}
