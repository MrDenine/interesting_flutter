/// Utility exceptions and helper classes
///
/// This module provides general utility exceptions and exception handling utilities
/// that don't fit into other specific categories.
///
/// ## Logger Configuration
///
/// The module uses the `logger` package for structured exception logging with
/// different severity levels:
///
/// - **Critical**: System-level failures (Firebase init, dependencies)
/// - **Error**: Functional failures (network, data, storage, business logic)
/// - **Warning**: Recoverable issues (UI, cache, not implemented)
/// - **Info**: Informational tracking
///
/// ### Usage Examples:
///
/// ```dart
/// // Basic exception logging
/// try {
///   await riskyOperation();
/// } catch (e) {
///   final appException = e.toAppException();
///   ExceptionUtils.logException(appException);
/// }
///
/// // Configure logger settings
/// ExceptionUtils.configureLogger(
///   printEmojis: false,
///   colors: false,
///   level: Level.warning,
/// );
///
/// // Set log level dynamically
/// ExceptionUtils.setLogLevel(Level.error);
/// ```
library;

import 'package:logger/logger.dart';
import '../types/base_exception.dart';
import '../types/network_exceptions.dart';
import '../types/firebase_exceptions.dart';
import '../types/graphql_exceptions.dart';
import '../types/data_exceptions.dart';
import '../types/business_logic_exceptions.dart';
import '../types/storage_exceptions.dart';
import '../types/ui_exceptions.dart';
import '../types/configuration_exceptions.dart';

/// Exception severity levels for logging
enum ExceptionSeverity {
  /// Critical system failures that prevent app functionality
  critical,

  /// Errors that affect user experience but don't crash the app
  error,

  /// Warnings for recoverable issues
  warning,

  /// Informational exceptions for tracking
  info,
}

/// Exception thrown when an operation is performed in an invalid state
class InvalidStateException extends AppException {
  final String? currentState;
  final String? expectedState;

  InvalidStateException({
    required super.message,
    this.currentState,
    this.expectedState,
    super.code = 'invalid_state',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'currentState': currentState,
        'expectedState': expectedState,
      };
}

/// Exception thrown when a required dependency is not available
class DependencyException extends AppException {
  final String? dependency;

  DependencyException({
    required super.message,
    this.dependency,
    super.code = 'dependency_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'dependency': dependency,
      };
}

/// Exception thrown when an operation is not implemented
class NotImplementedException extends AppException {
  final String? feature;

  NotImplementedException({
    String? message,
    this.feature,
    super.code = 'not_implemented',
    super.details,
    super.timestamp,
  }) : super(
          message:
              message ?? 'Feature not implemented: ${feature ?? 'Unknown'}',
        );

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'feature': feature,
      };
}

/// Generic exception for wrapping unknown exceptions
class GenericException extends AppException {
  final dynamic originalException;

  GenericException({
    required super.message,
    this.originalException,
    super.code = 'generic_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'originalException': originalException?.toString(),
      };
}

/// Utility class for working with exceptions
class ExceptionUtils {
  ExceptionUtils._();

  /// Logger instance for exception logging
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Convert a generic exception to an AppException
  static AppException fromException(dynamic exception,
      {String? fallbackMessage}) {
    if (exception is AppException) {
      return exception;
    }

    String message = fallbackMessage ?? 'An unexpected error occurred';

    if (exception != null) {
      message = exception.toString();
    }

    return GenericException(
      message: message,
      originalException: exception,
    );
  }

  /// Check if an exception is a network-related error
  static bool isNetworkException(dynamic exception) {
    return exception is NetworkException;
  }

  /// Check if an exception is recoverable (can be retried)
  static bool isRecoverable(AppException exception) {
    return exception is TimeoutException ||
        exception is NoInternetException ||
        exception is ServerException ||
        exception is FirebaseConnectionException ||
        exception is GraphQLNetworkException ||
        exception is CacheException;
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(AppException exception) {
    switch (exception.runtimeType) {
      case NoInternetException _:
        return 'Please check your internet connection and try again.';
      case TimeoutException _:
        return 'The request took too long. Please try again.';
      case ServerException _:
        final serverEx = exception as ServerException;
        if (serverEx.statusCode >= 500) {
          return 'Our servers are having issues. Please try again later.';
        }
        return 'Something went wrong. Please try again.';
      case DataNotFoundException _:
        return 'The requested information could not be found.';
      case PermissionDeniedException _:
        return 'You don\'t have permission to perform this action.';
      case FirebaseConnectionException _:
        return 'Connection to our services failed. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Log exception details using the logger package
  static void logException(AppException exception) {
    final Map<String, dynamic> exceptionData = {
      'type': exception.runtimeType.toString(),
      'message': exception.message,
      'code': exception.code,
      'timestamp': exception.timestamp.toIso8601String(),
      if (exception.details != null) 'details': exception.details,
    };

    // Determine log level based on exception severity
    final severity = _getExceptionSeverity(exception);

    switch (severity) {
      case ExceptionSeverity.critical:
        _logger.f('CRITICAL EXCEPTION',
            error: exception, stackTrace: StackTrace.current);
        _logger.d('Exception Data: $exceptionData');
        break;
      case ExceptionSeverity.error:
        _logger.e('ERROR EXCEPTION',
            error: exception, stackTrace: StackTrace.current);
        _logger.d('Exception Data: $exceptionData');
        break;
      case ExceptionSeverity.warning:
        _logger.w('WARNING EXCEPTION', error: exception);
        _logger.d('Exception Data: $exceptionData');
        break;
      case ExceptionSeverity.info:
        _logger.i('INFO EXCEPTION', error: exception);
        _logger.d('Exception Data: $exceptionData');
        break;
    }
  }

  /// Determine exception severity for logging
  static ExceptionSeverity _getExceptionSeverity(AppException exception) {
    // Critical: System-level failures
    if (exception is FirebaseInitializationException ||
        exception is DependencyException ||
        exception is InvalidConfigurationException) {
      return ExceptionSeverity.critical;
    }

    // Errors: Functional failures
    if (exception is NetworkException ||
        exception is DataException ||
        exception is StorageException ||
        exception is BusinessLogicException) {
      return ExceptionSeverity.error;
    }

    // Warnings: Recoverable issues
    if (exception is UIException ||
        exception is CacheException ||
        exception is NotImplementedException) {
      return ExceptionSeverity.warning;
    }

    // Default to error
    return ExceptionSeverity.error;
  }

  /// Set custom logger configuration
  static void configureLogger({
    int methodCount = 2,
    int errorMethodCount = 8,
    int lineLength = 120,
    bool colors = true,
    bool printEmojis = true,
    bool printTime = true,
    Level level = Level.debug,
  }) {
    Logger.level = level;
    // Note: Logger instance configuration is set during initialization
    // To change printer settings, you would need to create a new Logger instance
  }

  /// Enable/disable exception logging
  static void setLogLevel(Level level) {
    Logger.level = level;
  }
}
