import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/terms/repository/terms_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/splash/repository/splash_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('reads the current rules in both languages', () async {
    final api = FakeApi({'GET /api/v1/terms/current': (_) => (200, fixture('terms_current'))});

    final result = await TermsRepository(apiClient: api.client()).current();

    expect(result.failure, isNull);
    expect(result.terms!.version, 3);
    expect(result.terms!.accepted, isNull);
    expect(result.terms!.rules('en'), startsWith('1. Members'));
    expect(result.terms!.rules('bn'), startsWith('১.'));
    expect(result.terms!.rules('en'), contains('\n'));
  });

  test('accept sends the version and the idempotency key', () async {
    final api = FakeApi({'POST /api/v1/terms/accept': (_) => (200, envelope(null))});

    final result = await TermsRepository(apiClient: api.client()).accept(3, 'key-1');

    expect(result.failure, isNull);
    expect(api.last.data, {'version': 3, 'idempotency_key': 'key-1'});
  });

  test('maps a refused accept to a failure', () async {
    final api = FakeApi({'POST /api/v1/terms/accept': (_) => (422, envelopeError(422, 'outdated'))});

    final result = await TermsRepository(apiClient: api.client()).accept(2, 'key-1');

    expect(result.failure, isA<ValidationFailure>());
    expect(result.failure!.message, 'outdated');
  });

  test('auth/me tells the splash that the rules must be accepted', () async {
    final api = FakeApi({'GET /api/v1/auth/me': (_) => (200, fixture('me_terms_required'))});

    final me = await SplashRepository(apiClient: api.client()).me();

    expect(me.isValid, isTrue);
    expect(me.accountType, 'member');
    expect(me.termsRequired, isTrue);
  });
}
