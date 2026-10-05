import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:somobay_somiti_mobile_app/core/network/api_client.dart';

/// (status, JSON body) for a request; [request] gives access to body, query and headers.
typedef FakeHandler = (int, Map<String, dynamic>) Function(RequestOptions request);

/// Answers Dio requests from a "METHOD /path" → handler map, shaped like the real API envelope.
/// Records every request so tests can check what the app sent.
class FakeApi implements HttpClientAdapter {
  final Map<String, FakeHandler> routes;
  final List<RequestOptions> requests = [];

  FakeApi(this.routes);

  RequestOptions get last => requests.last;

  /// A Dio using this fake (no interceptors).
  Dio dio() => Dio(BaseOptions(baseUrl: 'http://test', headers: {'Accept': 'application/json'}))..httpClientAdapter = this;

  /// An [ApiClient] using this fake (no interceptors).
  ApiClient client() => ApiClient.forTesting(dio());

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    requests.add(options);
    final handler = routes['${options.method} ${options.path}'];
    final (status, body) = handler == null ? (404, envelopeError(404, 'not found')) : handler(options);

    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// A success envelope like the backend's.
Map<String, dynamic> envelope(Object? data, {Map<String, dynamic>? meta, int status = 200, String message = 'OK'}) => {
      'success': true,
      'statusCode': status,
      'message': message,
      'data': data,
      'errors': null,
      'meta': meta,
    };

/// An error envelope like the backend's.
Map<String, dynamic> envelopeError(int status, String message, {Map<String, List<String>>? errors}) => {
      'success': false,
      'statusCode': status,
      'message': message,
      'data': null,
      'errors': errors,
      'meta': null,
    };

/// Money as the API sends it.
Map<String, dynamic> money(int poisha, [String? display]) => {'poisha': poisha, 'display': display ?? '৳ $poisha'};

/// An enum value as the API sends it.
Map<String, dynamic> enumValue(String value, [String? label, String? color]) => {'value': value, 'label': label ?? value, 'color': color};
