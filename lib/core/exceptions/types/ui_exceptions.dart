/// UI-related exceptions
///
/// This module provides exception classes for handling UI-related errors
/// such as navigation failures, rendering issues, and image loading problems.
library;

import 'base_exception.dart';

/// Base class for UI-related exceptions
abstract class UIException extends AppException {
  UIException({
    required super.message,
    required super.code,
    super.details,
    super.timestamp,
  });
}

/// Exception thrown when navigation fails
class NavigationException extends UIException {
  final String? route;

  NavigationException({
    required super.message,
    this.route,
    super.code = 'navigation_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'route': route,
      };
}

/// Exception thrown when UI rendering fails
class RenderException extends UIException {
  final String? widgetName;

  RenderException({
    required super.message,
    this.widgetName,
    super.code = 'render_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'widgetName': widgetName,
      };
}

/// Exception thrown when image loading fails
class ImageLoadException extends UIException {
  final String? imageUrl;

  ImageLoadException({
    required super.message,
    this.imageUrl,
    super.code = 'image_load_error',
    super.details,
    super.timestamp,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'imageUrl': imageUrl,
      };
}
