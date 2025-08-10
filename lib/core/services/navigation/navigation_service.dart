import 'package:flutter/material.dart';

/// Global navigation service for handling navigation without BuildContext
/// This is useful for navigation from business logic, services, or static methods
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  static NavigationService get instance => _instance;

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get the current build context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Get the current navigator state
  NavigatorState? get navigator => navigatorKey.currentState;

  /// Navigate to a named route
  Future<T?> navigateTo<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace current route with a new route
  Future<T?> replaceWith<T extends Object?, TO extends Object?>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return navigator!.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Navigate and clear the entire stack
  Future<T?> navigateAndClear<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate and remove routes until a specific route
  Future<T?> navigateAndRemoveUntil<T extends Object?>(
    String routeName,
    String untilRoute, {
    Object? arguments,
  }) {
    return navigator!.pushNamedAndRemoveUntil<T>(
      routeName,
      ModalRoute.withName(untilRoute),
      arguments: arguments,
    );
  }

  /// Go back to the previous screen
  void goBack<T extends Object?>([T? result]) {
    if (navigator!.canPop()) {
      navigator!.pop<T>(result);
    }
  }

  /// Check if the navigator can pop
  bool canGoBack() {
    return navigator?.canPop() ?? false;
  }

  /// Show a dialog
  Future<T?> showDialogRoute<T>(Widget dialog) {
    return showDialog<T>(
      context: currentContext!,
      builder: (context) => dialog,
    );
  }

  /// Show a bottom sheet
  Future<T?> showBottomSheetRoute<T>(Widget bottomSheet) {
    return showModalBottomSheet<T>(
      context: currentContext!,
      builder: (context) => bottomSheet,
    );
  }

  /// Show a snackbar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }
}
