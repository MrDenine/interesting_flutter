/// Core exceptions for the application
///
/// This module provides a comprehensive exception hierarchy for handling
/// various types of errors that can occur in the application including
/// network errors, Firebase errors, GraphQL errors, and general application errors.
library;

// Export all exception types from organized directories
export 'types/base_exception.dart';
export 'types/network_exceptions.dart';
export 'types/firebase_exceptions.dart';
export 'types/graphql_exceptions.dart';
export 'types/data_exceptions.dart';
export 'types/storage_exceptions.dart';
export 'types/ui_exceptions.dart';
export 'types/business_logic_exceptions.dart';
export 'types/configuration_exceptions.dart';

// Export exception handlers and utilities
export 'handlers/exception_handler.dart';
export 'handlers/utility_exceptions.dart';
