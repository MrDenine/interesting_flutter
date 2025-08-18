/// Data-related exceptions
///
/// This module provides exception classes for handling data-related errors
/// such as parsing failures, validation errors, and missing data.
library;

import 'base_exception.dart';

/// Base class for data-related exceptions
abstract class DataException extends AppException {
  DataException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when data parsing fails
class DataParsingException extends DataException {
  final String? rawData;

  DataParsingException({
    required super.message,
    this.rawData,
    super.code = 'data_parsing_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'rawData': rawData,
      };
}

/// Exception thrown when required data is not found
class DataNotFoundException extends DataException {
  final String? resource;

  DataNotFoundException({
    required super.message,
    this.resource,
    super.code = 'data_not_found',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'resource': resource,
      };
}

/// Exception thrown when data validation fails
class DataValidationException extends DataException {
  final Map<String, List<String>>? validationErrors;

  DataValidationException({
    required super.message,
    this.validationErrors,
    super.code = 'data_validation_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'validationErrors': validationErrors,
      };
}

/// Exception thrown when cache operations fail
class CacheException extends DataException {
  final String? cacheKey;

  CacheException({
    required super.message,
    this.cacheKey,
    super.code = 'cache_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'cacheKey': cacheKey,
      };
}
