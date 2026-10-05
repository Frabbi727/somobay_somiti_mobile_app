import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/network/interceptors/auth_interceptor.dart';
import 'package:somobay_somiti_mobile_app/core/services/storage_service.dart';

import '../support/fake_api.dart';

/// Keeps tokens in memory instead of the device keychain.
class MemoryStorage extends StorageService {
  String? access;
  String? refresh;
  bool cleared = false;

  MemoryStorage({this.access, this.refresh});

  @override
  Future<void> saveTokens({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<String?> getAccessToken() async => access;

  @override
  Future<String?> getRefreshToken() async => refresh;

  @override
  Future<void> clearAuthData() async {
    access = null;
    refresh = null;
    cleared = true;
  }

  @override
  String getLanguageCode() => 'bn';
}

Map<String, dynamic> tokens(String access, String refresh) =>
    envelope({'access_token': access, 'refresh_token': refresh, 'token_type': 'Bearer', 'expires_in': 3600});

void main() {
  test('sends the token and language, refreshes once when parallel requests expire, and retries them', () async {
    final storage = MemoryStorage(access: 'old', refresh: 'r1');
    var refreshCalls = 0;
    final api = FakeApi({
      'GET ${ApiConstants.profile}': (r) => r.headers['Authorization'] == 'Bearer new' ? (200, envelope({'ok': 1})) : (401, envelopeError(401, 'x')),
      'GET ${ApiConstants.dues}': (r) => r.headers['Authorization'] == 'Bearer new' ? (200, envelope([])) : (401, envelopeError(401, 'x')),
      'POST ${ApiConstants.refreshToken}': (r) {
        refreshCalls++;
        return (200, tokens('new', 'r2'));
      },
    });
    final dio = api.dio();
    var expired = 0;
    dio.interceptors.add(AuthInterceptor(storageService: storage, dio: dio, onSessionExpired: () => expired++));

    final results = await Future.wait([dio.get(ApiConstants.profile), dio.get(ApiConstants.dues)]);

    expect(results.map((r) => r.statusCode), [200, 200]);
    expect(refreshCalls, 1);
    expect(storage.access, 'new');
    expect(storage.refresh, 'r2');
    expect(expired, 0);
    expect(api.requests.first.headers['Accept-Language'], 'bn');
  });

  test('signs out once when the refresh is refused, without looping', () async {
    final storage = MemoryStorage(access: 'old', refresh: 'spent');
    var refreshCalls = 0;
    final api = FakeApi({
      'GET ${ApiConstants.profile}': (r) => (401, envelopeError(401, 'Please sign in again.')),
      'POST ${ApiConstants.refreshToken}': (r) {
        refreshCalls++;
        return (401, envelopeError(401, 'Please sign in again.'));
      },
    });
    final dio = api.dio();
    var expired = 0;
    dio.interceptors.add(AuthInterceptor(storageService: storage, dio: dio, onSessionExpired: () => expired++));

    await expectLater(dio.get(ApiConstants.profile), throwsA(isA<DioException>()));

    expect(refreshCalls, 1);
    expect(storage.cleared, isTrue);
    expect(expired, 1);
  });

  test('never tries to refresh for a failed sign-in', () async {
    final storage = MemoryStorage();
    final api = FakeApi({
      'POST ${ApiConstants.login}': (r) => (401, envelopeError(401, 'x')),
    });
    final dio = api.dio();
    var expired = 0;
    dio.interceptors.add(AuthInterceptor(storageService: storage, dio: dio, onSessionExpired: () => expired++));

    await expectLater(dio.post(ApiConstants.login, data: {}), throwsA(isA<DioException>()));

    expect(api.requests.length, 1);
    expect(expired, 0);
  });
}
