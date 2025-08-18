/// Storage-related exceptions
///
/// This module provides exception classes for handling storage-related errors
/// such as file operations, permissions, and storage space issues.
library;

import 'base_exception.dart';

/// Base class for storage-related exceptions
abstract class StorageException extends AppException {
  StorageException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when file operations fail
class FileException extends StorageException {
  final String? filePath;

  FileException({
    required super.message,
    this.filePath,
    super.code = 'file_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'filePath': filePath,
      };
}

/// Exception thrown when storage permission is denied
class StoragePermissionException extends StorageException {
  StoragePermissionException({
    super.message = 'Storage permission denied',
    super.code = 'storage_permission_denied',
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when storage space is insufficient
class InsufficientStorageException extends StorageException {
  final int? requiredSpace;
  final int? availableSpace;

  InsufficientStorageException({
    this.requiredSpace,
    this.availableSpace,
    super.message = 'Insufficient storage space',
    super.code = 'insufficient_storage',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'requiredSpace': requiredSpace,
        'availableSpace': availableSpace,
      };
}
