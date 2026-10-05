import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/authentication/model/login_request_model.dart';
import 'package:somobay_somiti_mobile_app/modules/authentication/repository/auth_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/splash/repository/splash_repository.dart';

import '../support/fake_api.dart';

void main() {
  test('signs in with mobile and password and reads the token pair from the envelope', () async {
    final api = FakeApi({
      'POST ${ApiConstants.login}': (r) => (200, envelope({'access_token': 'a', 'refresh_token': 'r', 'token_type': 'Bearer', 'expires_in': 3600})),
    });

    final result = await AuthRepository(apiClient: api.client()).login(const LoginRequestModel(mobile: '01712345678', password: 'secret-123'));

    expect(result.failure, isNull);
    expect(result.tokens?.accessToken, 'a');
    expect(result.tokens?.refreshToken, 'r');
    expect(api.last.data, {'mobile': '01712345678', 'password': 'secret-123'});
  });

  test('signs in with an SMS code without sending a password', () async {
    final api = FakeApi({
      'POST ${ApiConstants.login}': (r) => (200, envelope({'access_token': 'a', 'refresh_token': 'r', 'token_type': 'Bearer', 'expires_in': 3600})),
      'POST ${ApiConstants.sendCode}': (r) => (200, envelope(null, message: 'sent')),
    });
    final repository = AuthRepository(apiClient: api.client());

    expect((await repository.sendCode('01712345678')).isSuccess, isTrue);
    expect(api.last.data, {'mobile': '01712345678'});

    await repository.login(const LoginRequestModel(mobile: '01712345678', code: '482913'));
    expect(api.last.data, {'mobile': '01712345678', 'code': '482913'});
  });

  test('turns a wrong password into a validation failure with the backend field message', () async {
    final api = FakeApi({
      'POST ${ApiConstants.login}': (r) => (422, envelopeError(422, 'm', errors: {'mobile': ['ভুল']})),
    });

    final result = await AuthRepository(apiClient: api.client()).login(const LoginRequestModel(mobile: '01712345678', password: 'x'));

    expect(result.tokens, isNull);
    expect(result.failure, isA<ValidationFailure>());
    expect(result.failure?.validationErrors?['mobile'], ['ভুল']);
  });

  test('reads the society info and checks the session', () async {
    final api = FakeApi({
      'GET ${ApiConstants.somitiInfo}': (r) => (200, envelope({
            'name': 'সবুজ', 'name_bn': 'সবুজ', 'name_en': 'Sabuj', 'registration_no': null, 'address': null,
            'phone': null, 'email': null, 'logo_url': null, 'otp_enabled': true,
          })),
      'GET ${ApiConstants.me}': (r) => (401, envelopeError(401, 'x')),
    });
    final repository = SplashRepository(apiClient: api.client());

    final info = await repository.somitiInfo();
    expect(info.info?.name, 'সবুজ');
    expect(info.info?.otpEnabled, isTrue);

    final me = await repository.me();
    expect(me.isValid, isFalse);
    expect(me.failure, isA<AuthenticationFailure>());
  });
}
