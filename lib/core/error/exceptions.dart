class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);
}

class ServerException extends AppException {
  const ServerException(super.message, [super.code]);
}

class CacheException extends AppException {
  const CacheException(super.message, [super.code]);
}

class PermissionException extends AppException {
  const PermissionException(super.message, [super.code]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}
