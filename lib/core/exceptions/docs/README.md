# Core Exceptions Module

A comprehensive exception handling system for the Flutter application, providing structured error management, logging, and user-friendly error handling.

## Overview

This module provides:

- **Hierarchical Exception System**: Well-organized exception hierarchy for different error types
- **Exception Handler**: Centralized exception handling and logging
- **Safe Execution**: Utilities for safe code execution with automatic exception handling
- **User-Friendly Messages**: Convert technical errors to user-friendly messages
- **Logging & Reporting**: Structured logging with severity levels

## Features

### Exception Types

#### Network Exceptions

- `NoInternetException`: No internet connectivity
- `TimeoutException`: Request timeout
- `ServerException`: Server errors (4xx, 5xx)

#### Firebase Exceptions

- `FirebaseInitializationException`: Firebase setup failures
- `FirebaseAuthException`: Authentication errors
- `FirebaseConfigurationException`: Configuration issues
- `FirebaseConnectionException`: Connection problems

#### GraphQL Exceptions

- `GraphQLQueryException`: Query execution failures
- `GraphQLMutationException`: Mutation failures
- `GraphQLSchemaException`: Schema validation errors
- `GraphQLNetworkException`: GraphQL network transport errors

#### Data Exceptions

- `DataParsingException`: JSON/data parsing failures
- `DataNotFoundException`: Missing data/resources
- `DataValidationException`: Data validation failures
- `CacheException`: Cache operation failures

#### Storage Exceptions

- `FileException`: File operation failures
- `StoragePermissionException`: Storage permission denied
- `InsufficientStorageException`: Insufficient storage space

#### UI Exceptions

- `NavigationException`: Navigation failures
- `RenderException`: UI rendering errors
- `ImageLoadException`: Image loading failures

#### Business Logic Exceptions

- `BusinessRuleViolationException`: Business rule violations
- `OperationNotAllowedException`: Forbidden operations
- `PermissionDeniedException`: Permission errors

#### Configuration Exceptions

- `MissingConfigurationException`: Missing configuration
- `InvalidConfigurationException`: Invalid configuration values

#### Utility Exceptions

- `InvalidStateException`: Invalid application state
- `DependencyException`: Missing dependencies
- `NotImplementedException`: Unimplemented features
- `GenericException`: Fallback for unknown exceptions

## Usage

### Basic Exception Handling

```dart
import 'package:interesting_flutter/core/exceptions/index.dart';

// Throwing exceptions
throw NoInternetException();
throw DataNotFoundException(
  message: 'User not found',
  resource: 'user',
  details: {'userId': '123'},
);

// Catching and converting exceptions
try {
  await riskyOperation();
} catch (e) {
  final appException = e.toAppException(
    context: 'User registration',
    details: {'step': 'validation'},
  );

  // Handle the exception
  ExceptionHandler.instance.logException(appException);

  // Show user-friendly message
  final userMessage = ExceptionHandler.instance.getUserMessage(appException);
  showErrorDialog(userMessage);
}
```

### Safe Execution

```dart
// Async execution with fallback
final userData = await SafeExecution.execute(
  () => userService.fetchUser(userId),
  context: 'Fetching user data',
  fallback: null,
);

// Sync execution with error handling
final result = SafeExecution.executeSync(
  () => complexCalculation(),
  context: 'Complex calculation',
  fallback: 0,
  shouldRethrow: false,
);
```

### Exception Handler Configuration

```dart
void setupExceptionHandler() {
  // Set custom exception callback
  ExceptionHandler.instance.onException = (exception) {
    // Send to analytics service
    analytics.recordError(exception);

    // Show user notification for critical errors
    if (exception is FirebaseInitializationException) {
      showCriticalErrorDialog(exception);
    }
  };
}
```

### GraphQL Exception Handling

```dart
Future<List<Launch>> fetchLaunches() async {
  try {
    final result = await graphQLClient.query(launchesQuery);
    return parseResult(result);
  } on gql.OperationException catch (e) {
    final appException = e.toAppException(context: 'Fetching SpaceX launches');

    if (appException is GraphQLNetworkException) {
      // Handle network issues
      throw NoInternetException();
    }

    throw appException;
  }
}
```

### Firebase Exception Handling

```dart
Future<void> initializeApp() async {
  try {
    await Firebase.initializeApp();
  } on firebase.FirebaseException catch (e) {
    final appException = e.toAppException(context: 'Firebase initialization');

    // Log and handle appropriately
    ExceptionHandler.instance.logException(appException);

    if (appException is FirebaseConfigurationException) {
      // Handle configuration issues
      showConfigurationError();
    }

    throw appException;
  }
}
```

## Exception Properties

All exceptions inherit from `AppException` and include:

```dart
abstract class AppException implements Exception {
  final String message;           // Human-readable error message
  final String code;             // Machine-readable error code
  final Map<String, dynamic>? details; // Additional context
  final DateTime timestamp;      // When the error occurred

  // Convert to map for logging/serialization
  Map<String, dynamic> toMap();
}
```

## Logging and Severity

The exception handler automatically determines severity levels:

- **Critical**: System-level failures (Firebase init, dependencies)
- **Error**: Functional failures (network, data, storage)
- **Warning**: Recoverable issues (UI, cache, not implemented)
- **Info**: Informational tracking

```dart
// Exceptions are automatically logged with appropriate severity
ExceptionHandler.instance.logException(exception);

// Manual severity checking
final severity = ExceptionHandler.instance._getExceptionSeverity(exception);
```

## User-Friendly Messages

Convert technical exceptions to user-friendly messages:

```dart
final userMessage = ExceptionUtils.getUserFriendlyMessage(exception);

// Examples:
// NoInternetException -> "Please check your internet connection and try again."
// ServerException(500) -> "Our servers are having issues. Please try again later."
// DataNotFoundException -> "The requested information could not be found."
```

## Integration with Existing Code

### Update Firebase Service

```dart
// In firebase_service.dart, replace:
throw FirebaseInitializationException('message', 'code');

// With:
throw FirebaseInitializationException(message: 'message');
```

### Update GraphQL DataSource

```dart
// In spacex_graphql_datasource.dart, replace:
throw Exception('Failed to fetch launches: ${result.exception}');

// With:
final appException = result.exception.toAppException(
  context: 'Fetching SpaceX launches',
);
throw appException;
```

## Best Practices

1. **Always use specific exception types** instead of generic `Exception`
2. **Provide context** when converting exceptions
3. **Include relevant details** for debugging
4. **Use SafeExecution** for risky operations
5. **Set up global exception handling** early in app initialization
6. **Convert technical errors** to user-friendly messages
7. **Log exceptions** with appropriate severity levels
8. **Handle recoverable exceptions** gracefully

## Testing

```dart
// Test exception throwing
expect(
  () => service.processData(invalidData),
  throwsA(isA<DataValidationException>()),
);

// Test exception handling
final result = await SafeExecution.execute(
  () => throw NoInternetException(),
  fallback: 'offline_data',
);
expect(result, equals('offline_data'));

// Test exception conversion
final appException = Exception('test').toAppException(context: 'testing');
expect(appException, isA<GenericException>());
```

## Migration Guide

### From Generic Exceptions

```dart
// Before
throw Exception('Network error');

// After
throw NoInternetException();
```

### From Custom Exception Classes

```dart
// Before
class CustomError implements Exception {
  final String message;
  CustomError(this.message);
}

// After
class CustomError extends BusinessLogicException {
  CustomError({required String message}) : super(
    message: message,
    code: 'custom_error',
  );
}
```

## Future Enhancements

- [ ] Integration with crash reporting services (Crashlytics, Sentry)
- [ ] Exception analytics and metrics
- [ ] Localized error messages
- [ ] Retry mechanisms for recoverable exceptions
- [ ] Exception rate limiting
- [ ] Custom exception templates

## Contributing

When adding new exception types:

1. Choose the appropriate base class
2. Provide meaningful error codes
3. Include relevant additional properties
4. Update this documentation
5. Add tests for the new exception type

## Dependencies

- `dart:developer` - For logging
- `flutter/foundation.dart` - For Flutter debugging utilities
- `graphql_flutter` - For GraphQL exception handling
- `firebase_core` - For Firebase exception handling
