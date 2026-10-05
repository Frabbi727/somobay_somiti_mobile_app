class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? errors;

  const ServerException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => 'ServerException: $message ($statusCode)';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Cache operation failed'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException({this.message = 'Authentication failed'});

  @override
  String toString() => 'AuthException: $message';
}
