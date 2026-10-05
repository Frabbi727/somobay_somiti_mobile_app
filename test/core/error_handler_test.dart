import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/errors/error_handler.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';

DioException respond(int status, Map<String, dynamic> body) => DioException(
      requestOptions: RequestOptions(path: '/x'),
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: RequestOptions(path: '/x'), statusCode: status, data: body),
    );

void main() {
  test('maps every API status to a member-friendly failure carrying the backend message', () {
    expect(ErrorHandler.handleException(respond(401, {'message': 'x'})), isA<AuthenticationFailure>());
    expect(ErrorHandler.handleException(respond(403, {'message': 'নেই'})), isA<ForbiddenFailure>());
    expect(ErrorHandler.handleException(respond(404, {'message': 'পাওয়া যায়নি।'})).message, 'পাওয়া যায়নি।');
    expect(ErrorHandler.handleException(respond(409, {'message': 'c'})), isA<ConflictFailure>());
    expect(ErrorHandler.handleException(respond(429, {'message': 't'})), isA<RateLimitFailure>());

    final validation = ErrorHandler.handleException(respond(422, {
      'message': 'm',
      'errors': {'amount': ['bad']},
    })) as ValidationFailure;
    expect(validation.validationErrors?['amount'], ['bad']);

    final server = ErrorHandler.handleException(respond(500, {'message': 'SQLSTATE boom'}));
    expect(server, isA<ServerFailure>());
    expect(server.message, 'error_server');
  });
}
