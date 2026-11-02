import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/network/interceptors/terms_interceptor.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';
import 'auth_interceptor_test.dart' show MemoryStorage;

void main() {
  late int opened;

  Dio dioFor(FakeApi api, {String? accountType}) {
    final dio = api.dio();
    dio.interceptors.add(TermsInterceptor(storageService: MemoryStorage(access: 'a', refresh: 'r', accountType: accountType), onRequired: () => opened++));
    return dio;
  }

  setUp(() {
    opened = 0;
    TermsInterceptor.reset();
  });

  test('a 403 terms_acceptance_required opens accept-rules once', () async {
    final api = FakeApi({
      'GET /a': (_) => (403, fixture('error_403_terms_required')),
      'GET /b': (_) => (403, fixture('error_403_terms_required')),
    });
    final dio = dioFor(api);

    // Several requests fail together; the error still reaches every caller.
    final results = await Future.wait([
      dio.get('/a').then((_) => 'ok', onError: (e) => (e as DioException).response!.statusCode.toString()),
      dio.get('/b').then((_) => 'ok', onError: (e) => (e as DioException).response!.statusCode.toString()),
      dio.get('/a').then((_) => 'ok', onError: (e) => (e as DioException).response!.statusCode.toString()),
    ]);

    expect(results, ['403', '403', '403']);
    expect(opened, 1);
  });

  test('opens again after the flag is reset (accepted, or logged out)', () async {
    final api = FakeApi({'GET /a': (_) => (403, fixture('error_403_terms_required'))});
    final dio = dioFor(api);

    await dio.get('/a').then((_) {}, onError: (_) {});
    TermsInterceptor.reset();
    await dio.get('/a').then((_) {}, onError: (_) {});

    expect(opened, 2);
  });

  test('a failing navigation still passes the error on and lets the next 403 try again', () async {
    final api = FakeApi({'GET /a': (_) => (403, fixture('error_403_terms_required'))});
    final dio = api.dio();
    var attempts = 0;
    dio.interceptors.add(TermsInterceptor(
      storageService: MemoryStorage(access: 'a', refresh: 'r'),
      onRequired: () {
        attempts++;
        if (attempts == 1) throw StateError('no navigator');
      },
    ));

    final first = await dio.get('/a').then((_) => 'ok', onError: (e) => (e as DioException).response!.statusCode.toString());
    await dio.get('/a').then((_) {}, onError: (_) {});

    expect(first, '403');
    expect(attempts, 2);
  });

  test('other errors are passed on without opening anything', () async {
    final api = FakeApi({
      'GET /plain': (_) => (403, envelopeError(403, 'forbidden')),
      'GET /boom': (_) => (500, envelopeError(500, 'boom')),
    });
    final dio = dioFor(api);

    await dio.get('/plain').then((_) {}, onError: (_) {});
    await dio.get('/boom').then((_) {}, onError: (_) {});

    expect(opened, 0);
  });

  test('an applicant is never sent to accept-rules', () async {
    final api = FakeApi({'GET /a': (_) => (403, fixture('error_403_terms_required'))});
    final dio = dioFor(api, accountType: 'applicant');

    await dio.get('/a').then((_) {}, onError: (_) {});

    expect(opened, 0);
  });
}
