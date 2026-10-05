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

        if (statusCode == 401) {
          return const AuthenticationFailure();
        } else if (statusCode == 422) {
          return ValidationFailure(message: message, errors: validationErrors);
        } else {
          return ServerFailure(message: message, statusCode: statusCode);
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
