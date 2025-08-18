/// Exception handling utilities for centralized error management
///
/// This module provides utilities for handling, logging, and converting
/// exceptions in a consistent manner throughout the application.
library;

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as gql;
import 'package:firebase_core/firebase_core.dart' as firebase;

import '../types/base_exception.dart';
import '../types/network_exceptions.dart';
import '../types/firebase_exceptions.dart';
import '../types/graphql_exceptions.dart';
import '../types/data_exceptions.dart';
import '../types/storage_exceptions.dart';
import '../types/ui_exceptions.dart';
import '../types/business_logic_exceptions.dart';
import '../types/configuration_exceptions.dart';
import 'utility_exceptions.dart';

/// Global exception handler for the application
class ExceptionHandler {
  ExceptionHandler._();

  static final ExceptionHandler _instance = ExceptionHandler._();
  static ExceptionHandler get instance => _instance;

  /// Global exception callback for custom handling
  Function(AppException exception)? onException;

  /// Handle any exception and convert it to an AppException
  AppException handle(
    dynamic exception, {
    String? context,
    Map<String, dynamic>? additionalDetails,
  }) {
    final AppException appException = _convertToAppException(
      exception,
      context: context,
      additionalDetails: additionalDetails,
    );

    // Log the exception
    logException(appException);

    // Call custom exception handler if provided
    onException?.call(appException);

    return appException;
  }

  /// Convert any exception to an AppException
  AppException _convertToAppException(
    dynamic exception, {
    String? context,
    Map<String, dynamic>? additionalDetails,
  }) {
    // If it's already an AppException, return as is
    if (exception is AppException) {
      return exception;
    }

    // Handle GraphQL exceptions
    if (exception is gql.OperationException) {
      return _handleGraphQLException(exception, context, additionalDetails);
    }

    // Handle Firebase exceptions
    if (exception is firebase.FirebaseException) {
      return _handleFirebaseException(exception, context, additionalDetails);
    }

    // Handle common Dart exceptions
    if (exception is ArgumentError) {
      return DataValidationException(
        message: 'Invalid argument: ${exception.message}',
        details: _mergeDetails({'argument': exception.name}, additionalDetails),
      );
    }

    if (exception is FormatException) {
      return DataParsingException(
        message: 'Data format error: ${exception.message}',
        rawData: exception.source,
        details: _mergeDetails({'offset': exception.offset}, additionalDetails),
      );
    }

    if (exception is TypeError) {
      return DataParsingException(
        message: 'Type error: ${exception.toString()}',
        details: additionalDetails,
      );
    }

    if (exception is StateError) {
      return InvalidStateException(
        message: 'Invalid state: ${exception.message}',
        details: additionalDetails,
      );
    }

    if (exception is UnsupportedError) {
      return NotImplementedException(
        message: 'Unsupported operation: ${exception.message}',
        details: additionalDetails,
      );
    }

    // Default to generic exception
    return GenericException(
      message: context != null
          ? '$context: ${exception.toString()}'
          : exception?.toString() ?? 'Unknown error occurred',
      originalException: exception,
      details: additionalDetails,
    );
  }

  /// Handle GraphQL-specific exceptions
  AppException _handleGraphQLException(
    gql.OperationException exception,
    String? context,
    Map<String, dynamic>? additionalDetails,
  ) {
    // Check for network errors
    if (exception.linkException != null) {
      final linkException = exception.linkException!;

      if (linkException is gql.NetworkException) {
        return GraphQLNetworkException(
          message: 'GraphQL network error: ${linkException.message}',
          details: additionalDetails,
        );
      }

      if (linkException is gql.ServerException) {
        return ServerException(
          statusCode: linkException.statusCode ?? 500,
          message:
              'GraphQL server error: ${linkException.originalException?.toString() ?? 'Unknown server error'}',
          details: additionalDetails,
        );
      }

      return GraphQLNetworkException(
        message: 'GraphQL link error: ${linkException.toString()}',
        details: additionalDetails,
      );
    }

    // Handle GraphQL errors
    if (exception.graphqlErrors.isNotEmpty) {
      final errors = exception.graphqlErrors.map((e) => e.message).toList();
      return GraphQLQueryException(
        query: context ?? 'unknown',
        errors: errors,
        message: 'GraphQL errors: ${errors.join(', ')}',
        details: _mergeDetails({
          'graphqlErrors': exception.graphqlErrors
              .map((e) => {
                    'message': e.message,
                    'path': e.path,
                    'locations': e.locations
                        ?.map((l) => {'line': l.line, 'column': l.column})
                        .toList(),
                  })
              .toList(),
        }, additionalDetails),
      );
    }

    return GraphQLQueryException(
      query: context ?? 'unknown',
      message: 'GraphQL operation failed: ${exception.toString()}',
      details: additionalDetails,
    );
  }

  /// Handle Firebase-specific exceptions
  AppException _handleFirebaseException(
    firebase.FirebaseException exception,
    String? context,
    Map<String, dynamic>? additionalDetails,
  ) {
    switch (exception.code) {
      case 'network-request-failed':
        return FirebaseConnectionException(
          message: 'Firebase network error: ${exception.message}',
          details: _mergeDetails({'code': exception.code}, additionalDetails),
        );

      case 'too-many-requests':
        return ServerException(
          statusCode: 429,
          message: 'Too many requests: ${exception.message}',
          details: _mergeDetails({'code': exception.code}, additionalDetails),
        );

      case 'permission-denied':
        return PermissionDeniedException(
          message: 'Firebase permission denied: ${exception.message}',
          details: _mergeDetails({'code': exception.code}, additionalDetails),
        );

      case 'unavailable':
        return ServerException(
          statusCode: 503,
          message: 'Firebase service unavailable: ${exception.message}',
          details: _mergeDetails({'code': exception.code}, additionalDetails),
        );

      default:
        return FirebaseConnectionException(
          message: 'Firebase error: ${exception.message}',
          details: _mergeDetails(
              {'plugin': exception.plugin, 'code': exception.code},
              additionalDetails),
        );
    }
  }

  /// Merge additional details with existing details
  Map<String, dynamic>? _mergeDetails(
    Map<String, dynamic>? baseDetails,
    Map<String, dynamic>? additionalDetails,
  ) {
    if (baseDetails == null && additionalDetails == null) return null;

    return {
      ...?baseDetails,
      ...?additionalDetails,
    };
  }

  /// Log exception with appropriate level
  void logException(AppException exception) {
    final severity = _getExceptionSeverity(exception);
    final logMessage = _formatLogMessage(exception);

    switch (severity) {
      case ExceptionSeverity.critical:
        _logCritical(logMessage, exception);
        break;
      case ExceptionSeverity.error:
        _logError(logMessage, exception);
        break;
      case ExceptionSeverity.warning:
        _logWarning(logMessage, exception);
        break;
      case ExceptionSeverity.info:
        _logInfo(logMessage, exception);
        break;
    }
  }

  /// Determine exception severity
  ExceptionSeverity _getExceptionSeverity(AppException exception) {
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

  /// Format log message
  String _formatLogMessage(AppException exception) {
    final buffer = StringBuffer();
    buffer.writeln('=== EXCEPTION ===');
    buffer.writeln('Type: ${exception.runtimeType}');
    buffer.writeln('Code: ${exception.code}');
    buffer.writeln('Message: ${exception.message}');
    buffer.writeln('Timestamp: ${exception.timestamp.toIso8601String()}');

    if (exception.details != null && exception.details!.isNotEmpty) {
      buffer.writeln('Details: ${exception.details}');
    }

    buffer.writeln('==================');
    return buffer.toString();
  }

  /// Log critical exceptions
  void _logCritical(String message, AppException exception) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'CRITICAL',
        error: exception,
        stackTrace: StackTrace.current,
        level: 1000, // Critical level
      );
    }
    // In production, you might want to send this to a crash reporting service
    debugPrint('CRITICAL: $message');
  }

  /// Log error exceptions
  void _logError(String message, AppException exception) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'ERROR',
        error: exception,
        stackTrace: StackTrace.current,
        level: 900, // Error level
      );
    }
    debugPrint('ERROR: $message');
  }

  /// Log warning exceptions
  void _logWarning(String message, AppException exception) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'WARNING',
        error: exception,
        level: 800, // Warning level
      );
    }
    debugPrint('WARNING: $message');
  }

  /// Log info exceptions
  void _logInfo(String message, AppException exception) {
    if (kDebugMode) {
      developer.log(
        message,
        name: 'INFO',
        error: exception,
        level: 700, // Info level
      );
    }
    debugPrint('INFO: $message');
  }

  /// Get user-friendly error message for display
  String getUserMessage(AppException exception) {
    return ExceptionUtils.getUserFriendlyMessage(exception);
  }

  /// Check if exception is recoverable
  bool isRecoverable(AppException exception) {
    return ExceptionUtils.isRecoverable(exception);
  }

  /// Report exception to external services (analytics, crash reporting, etc.)
  Future<void> reportException(AppException exception) async {
    // TODO: Implement external reporting
    // Examples:
    // - Firebase Crashlytics
    // - Sentry
    // - Bugsnag
    // - Custom analytics service

    if (kDebugMode) {
      debugPrint('Would report exception: ${exception.code}');
    }
  }
}

/// Extension to make exception handling more convenient
extension ExceptionHandlerExtension on dynamic {
  /// Convert any exception to AppException using the global handler
  AppException toAppException({
    String? context,
    Map<String, dynamic>? details,
  }) {
    return ExceptionHandler.instance.handle(
      this,
      context: context,
      additionalDetails: details,
    );
  }
}

/// Wrapper for safe execution with exception handling
class SafeExecution {
  /// Execute a function safely and handle any exceptions
  static Future<T?> execute<T>(
    Future<T> Function() function, {
    String? context,
    T? fallback,
    bool shouldRethrow = false,
    Map<String, dynamic>? details,
  }) async {
    try {
      return await function();
    } catch (e) {
      final appException = ExceptionHandler.instance.handle(
        e,
        context: context,
        additionalDetails: details,
      );

      if (shouldRethrow) {
        throw appException;
      }

      return fallback;
    }
  }

  /// Execute a synchronous function safely
  static T? executeSync<T>(
    T Function() function, {
    String? context,
    T? fallback,
    bool shouldRethrow = false,
    Map<String, dynamic>? details,
  }) {
    try {
      return function();
    } catch (e) {
      final appException = ExceptionHandler.instance.handle(
        e,
        context: context,
        additionalDetails: details,
      );

      if (shouldRethrow) {
        throw appException;
      }

      return fallback;
    }
  }
}
