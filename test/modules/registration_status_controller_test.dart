import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/app/routes/app_routes.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_status_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/model/registration_model.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/registration_repository.dart';

import '../support/fixtures.dart';

class FakeRegistrationRepository implements IRegistrationRepository {
  String? account = 'applicant';
  Failure? accountFailure;
  int registrationCalls = 0;

  @override
  Future<({Failure? failure, String? accountType})> accountType() async => (failure: accountFailure, accountType: accountFailure == null ? account : null);

  @override
  Future<RegistrationResult> getRegistration() async {
    registrationCalls++;
    return (failure: null, registration: RegistrationModel.fromJson(fixture('registration_submitted')['data'] as Map<String, dynamic>));
  }

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  test('shows the registration while the person is still registering', () async {
    final repository = FakeRegistrationRepository();
    final controller = RegistrationStatusController(repository: repository);

    expect(await controller.refresh(), isNull);
    expect(controller.state.value.data!.headline, contains('অনুমোদনের অপেক্ষায়'));
  });

  test('leaves for the dashboard as soon as the account became a member', () async {
    final repository = FakeRegistrationRepository()..account = 'member';
    final controller = RegistrationStatusController(repository: repository);

    expect(await controller.refresh(), AppRoutes.dashboard);
    expect(repository.registrationCalls, 0);
  });

  test('shows an error state, not a sign-out, when offline', () async {
    final repository = FakeRegistrationRepository()..accountFailure = const NetworkFailure();
    final controller = RegistrationStatusController(repository: repository);

    expect(await controller.refresh(), isNull);
    expect(controller.state.value.isError, isTrue);
  });
}
