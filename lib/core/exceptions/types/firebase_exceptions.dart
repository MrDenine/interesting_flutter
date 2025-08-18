/// Firebase-related exceptions
///
/// This module provides exception classes for handling Firebase-related errors
/// such as initialization failures, authentication errors, and connection issues.
library;

import 'base_exception.dart';

/// Base class for Firebase-related exceptions
abstract class FirebaseException extends AppException {
  FirebaseException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when Firebase initialization fails
class FirebaseInitializationException extends FirebaseException {
  FirebaseInitializationException({
    required super.message,
    super.code = 'firebase_init_error',
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when Firebase authentication fails
class FirebaseAuthException extends FirebaseException {
  FirebaseAuthException({
    required super.message,
    super.code = 'firebase_auth_error',
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when Firebase configuration is invalid
class FirebaseConfigurationException extends FirebaseException {
  FirebaseConfigurationException({
    required super.message,
    super.code = 'firebase_config_error',
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when Firebase connection fails
class FirebaseConnectionException extends FirebaseException {
  FirebaseConnectionException({
    required super.message,
    super.code = 'firebase_connection_error',
    super.details,
    super.timestamp,
  });
}
