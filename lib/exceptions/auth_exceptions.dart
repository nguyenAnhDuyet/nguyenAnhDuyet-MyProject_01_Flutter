class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AuthException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException({String? message})
      : super(
          message: message ?? 'Invalid email or password',
          code: 'INVALID_CREDENTIALS',
        );
}

class NetworkException extends AuthException {
  NetworkException({String? message, dynamic originalError})
      : super(
          message: message ?? 'Network error occurred',
          code: 'NETWORK_ERROR',
          originalError: originalError,
        );
}

class ServerException extends AuthException {
  ServerException({String? message, String? code, dynamic originalError})
      : super(
          message: message ?? 'Server error occurred',
          code: code ?? 'SERVER_ERROR',
          originalError: originalError,
        );
} 