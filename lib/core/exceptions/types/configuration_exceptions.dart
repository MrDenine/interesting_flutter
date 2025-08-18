/// Configuration-related exceptions
///
/// This module provides exception classes for handling configuration errors
/// such as missing settings and invalid configuration values.
library;

import 'base_exception.dart';

/// Base class for configuration-related exceptions
abstract class ConfigurationException extends AppException {
  ConfigurationException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when configuration is missing
class MissingConfigurationException extends ConfigurationException {
  final String? configKey;

  MissingConfigurationException({
    required super.message,
    this.configKey,
    super.code = 'missing_configuration',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'configKey': configKey,
      };
}

/// Exception thrown when configuration is invalid
class InvalidConfigurationException extends ConfigurationException {
  final String? configKey;
  final dynamic configValue;

  InvalidConfigurationException({
    required super.message,
    this.configKey,
    this.configValue,
    super.code = 'invalid_configuration',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'configKey': configKey,
        'configValue': configValue,
      };
}
