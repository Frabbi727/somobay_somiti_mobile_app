abstract class Failure {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;

  const Failure({
    required this.message,
    this.statusCode,
    this.validationErrors,
  });

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String? message,
  }) : super(message: message ?? 'error_no_internet');
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? statusCode,
  }) : super(message: message, statusCode: statusCode);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    String? message,
  }) : super(message: message ?? 'error_session_expired', statusCode: 401);
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    Map<String, List<String>>? errors,
  }) : super(message: message, statusCode: 422, validationErrors: errors);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    String? message,
  }) : super(message: message ?? 'error_timeout');
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    String? message,
  }) : super(message: message ?? 'error_unknown');
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure({
    String? message,
  }) : super(message: message ?? 'error_forbidden', statusCode: 403);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    String? message,
  }) : super(message: message ?? 'error_not_found', statusCode: 404);
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    String? message,
  }) : super(message: message ?? 'error_conflict', statusCode: 409);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure({
    String? message,
  }) : super(message: message ?? 'error_too_many', statusCode: 429);
}
