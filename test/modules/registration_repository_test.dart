import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/registration_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('reads the registration with server labels and timeline', () async {
    final api = FakeApi({'GET /api/v1/registration': (_) => (200, fixture('registration_submitted'))});

    final result = await RegistrationRepository(apiClient: api.client()).getRegistration();

    expect(result.failure, isNull);
    expect(result.registration!.status.value, 'submitted');
    expect(result.registration!.nextAction, 'wait');
    expect(result.registration!.timeline.map((s) => s.state), ['done', 'pending', 'waiting', 'waiting']);
    expect(result.registration!.data.nominees.single.relation, 'স্বামী/স্ত্রী');
  });

  test('saves only the fields it is given', () async {
    final api = FakeApi({'PUT /api/v1/registration': (_) => (200, fixture('registration_invited'))});

    await RegistrationRepository(apiClient: api.client()).saveDraft({'name_bn': 'করিম মিয়া'});

    expect(api.last.data, {'name_bn': 'করিম মিয়া'});
  });

  test('sends the idempotency key and maps a reused key to a conflict', () async {
    final api = FakeApi({'POST /api/v1/registration/submit': (_) => (409, envelopeError(409, 'already used'))});

    final result = await RegistrationRepository(apiClient: api.client()).submit('3f0c…');

    expect(api.last.data, {'idempotency_key': '3f0c…'});
    expect(result.failure, isA<ConflictFailure>());
  });

  test('shows field errors from a 422', () async {
    final api = FakeApi({
      'PUT /api/v1/registration': (_) => (422, envelopeError(422, 'invalid', errors: {'nid': ['NID must have 10, 13 or 17 digits.']})),
    });

    final result = await RegistrationRepository(apiClient: api.client()).saveDraft({'nid': '12'});

    expect(result.failure, isA<ValidationFailure>());
    expect(result.failure!.validationErrors!['nid']!.first, contains('NID'));
  });

  test('reads the relation list and the account type', () async {
    final api = FakeApi({
      'GET /api/v1/config/nominee-relations': (_) => (200, fixture('nominee_relations')),
      'GET /api/v1/auth/me': (_) => (200, envelope({'account_type': 'member', 'member_no': 'M-0007'})),
    });
    final repository = RegistrationRepository(apiClient: api.client());

    expect((await repository.relations()).relations.map((r) => r.label), ['পিতা', 'স্বামী/স্ত্রী']);
    expect((await repository.accountType()).accountType, 'member');
  });
}
