import 'dart:io';
import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure handleException(dynamic exception) {
    if (exception is DioException) {
      return _handleDioError(exception);
    } else if (exception is SocketException) {
      return const NetworkFailure();
    } else if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is AuthException) {
      return AuthenticationFailure(message: exception.message);
    } else if (exception is Failure) {
      return exception;
    } else {
      return UnknownFailure(message: exception.toString());
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;

        String message = 'error_server';
        Map<String, List<String>>? validationErrors;

        if (responseData is Map<String, dynamic>) {
          if (responseData['message'] != null) {
            message = responseData['message'].toString();
          }
          if (responseData['errors'] is Map) {
            validationErrors = (responseData['errors'] as Map).map(
              (key, value) => MapEntry(
                key.toString(),
                (value as List).map((e) => e.toString()).toList(),
              ),
            );
          }
        }

        switch (statusCode) {
          case 401:
            return const AuthenticationFailure();
          case 403:
            return ForbiddenFailure(message: message);
          case 404:
            return NotFoundFailure(message: message);
          case 409:
            return ConflictFailure(message: message);
          case 422:
            return ValidationFailure(message: message, errors: validationErrors);
          case 429:
            return RateLimitFailure(message: message);
          default:
            // 5xx: never show the server's text (it may be technical); use the app's own message.
            return ServerFailure(
              message: (statusCode ?? 500) >= 500 ? 'error_server' : message,
              statusCode: statusCode,
            );
        }

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'error_cancelled');

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        if (error.error is SocketException) {
          return const NetworkFailure();
        }
        return const UnknownFailure();
    }
  }
}
