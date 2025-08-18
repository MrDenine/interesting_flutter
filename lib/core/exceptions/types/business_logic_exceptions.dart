/// Business logic exceptions
///
/// This module provides exception classes for handling business logic errors
/// such as rule violations, unauthorized operations, and permission issues.
library;

import 'base_exception.dart';

/// Base class for business logic exceptions
abstract class BusinessLogicException extends AppException {
  BusinessLogicException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when a business rule is violated
class BusinessRuleViolationException extends BusinessLogicException {
  final String? rule;

  BusinessRuleViolationException({
    required super.message,
    this.rule,
    super.code = 'business_rule_violation',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'rule': rule,
      };
}

/// Exception thrown when an operation is not allowed
class OperationNotAllowedException extends BusinessLogicException {
  final String? operation;

  OperationNotAllowedException({
    required super.message,
    this.operation,
    super.code = 'operation_not_allowed',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'operation': operation,
      };
}

/// Exception thrown when required permissions are missing
class PermissionDeniedException extends BusinessLogicException {
  final String? permission;

  PermissionDeniedException({
    required super.message,
    this.permission,
    super.code = 'permission_denied',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'permission': permission,
      };
}
