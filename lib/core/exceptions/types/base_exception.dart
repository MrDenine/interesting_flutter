/// Base exception class for all custom exceptions in the application
///
/// This module provides the foundational exception class that all other
/// custom exceptions in the application should extend.
library;

/// Base exception class for all custom exceptions in the application
abstract class AppException implements Exception {
  /// The error message
  final String message;

  /// The error code for programmatic handling
  final String code;

  /// Additional context or details about the error
  final Map<String, dynamic>? details;

  /// The timestamp when the error occurred
  final DateTime timestamp;

  AppException({
    required this.message,
    required this.code,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '$runtimeType: $message (Code: $code)';

  /// Convert exception to a map for logging or serialization
  Map<String, dynamic> toMap() => {
        'type': runtimeType.toString(),
        'message': message,
        'code': code,
        'details': details,
        'timestamp': timestamp.toIso8601String(),
      };
}
