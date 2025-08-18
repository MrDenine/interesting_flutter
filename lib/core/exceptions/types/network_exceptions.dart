/// Network-related exceptions
///
/// This module provides exception classes for handling network-related errors
/// such as connectivity issues, timeouts, and server errors.
library;

import 'base_exception.dart';

/// Base class for network-related exceptions
abstract class NetworkException extends AppException {
  NetworkException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when there's no internet connection
class NoInternetException extends NetworkException {
  NoInternetException({
    super.message = 'No internet connection available',
    super.code = 'no_internet',
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when a network request times out
class TimeoutException extends NetworkException {
  final Duration timeout;

  TimeoutException({
    required this.timeout,
    super.message = 'Request timed out',
    super.code = 'timeout',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'timeout': timeout.inMilliseconds,
      };
}

/// Exception thrown when a server returns an error status code
class ServerException extends NetworkException {
  final int statusCode;

  ServerException({
    required this.statusCode,
    String? message,
    super.code = 'server_error',
    super.details,
    super.timestamp,
  }) : super(
          message: message ?? 'Server error (Status: $statusCode)',
        );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'statusCode': statusCode,
      };
}
