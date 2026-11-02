import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/app/routes/app_routes.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/profile_settings/repository/profile_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/terms/controller/accept_rules_controller.dart';

import '../core/auth_interceptor_test.dart' show MemoryStorage;
import '../support/fake_terms_repository.dart';

class FakeProfileRepository implements IProfileRepository {
  int logouts = 0;

  @override
  Future<({Failure? failure, bool isSuccess})> logout() async {
    logouts++;
    return (failure: null, isSuccess: true);
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late FakeTermsRepository terms;
  late List<String> routes;
  late AcceptRulesController controller;

  setUp(() async {
    terms = FakeTermsRepository();
    routes = [];
    controller = AcceptRulesController(repository: terms, profileRepository: FakeProfileRepository(), storageService: MemoryStorage(access: 'a', refresh: 'r'), navigate: routes.add);
    await controller.load();
  });

  test('accepting returns to the member home', () async {
    controller.agreed.value = true;

    expect(await controller.accept(), isTrue);

    expect(terms.accepted.single.version, 3);
    expect(routes, [AppRoutes.dashboard]);
  });

  test('accepting needs the box ticked', () async {
    expect(await controller.accept(), isFalse);

    expect(terms.accepted, isEmpty);
    expect(routes, isEmpty);
  });

  test('retrying accept reuses the key', () async {
    terms.acceptAnswers.add(const TimeoutFailure());
    controller.agreed.value = true;

    expect(await controller.accept(), isFalse);
    expect(controller.failure.value, isA<TimeoutFailure>());
    expect(routes, isEmpty);
    expect(await controller.accept(), isTrue);

    expect(terms.accepted, hasLength(2));
    expect(terms.accepted[1].key, terms.accepted[0].key);
  });

  test('rules that changed meanwhile are reloaded, unticked and get a new key', () async {
    terms.acceptAnswers.add(const ValidationFailure(message: 'outdated'));
    controller.agreed.value = true;
    terms.version = 4;

    expect(await controller.accept(), isFalse);

    expect(controller.terms.value!.version, 4);
    expect(controller.agreed.value, isFalse);
    expect(controller.failure.value!.message, 'outdated');

    controller.agreed.value = true;
    expect(await controller.accept(), isTrue);
    expect(terms.accepted[1].version, 4);
    expect(terms.accepted[1].key, isNot(terms.accepted[0].key));
  });

  test('logging out signs out and opens the login screen', () async {
    await controller.logout();

    expect(routes, [AppRoutes.login]);
  });
}
