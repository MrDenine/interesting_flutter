import 'package:flutter/material.dart';

/// Custom page transitions for the app
enum PageTransitionType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  fade,
  scale,
  rotation,
}

/// Custom page route builder with various transition animations
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final PageTransitionType transitionType;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.transitionType = PageTransitionType.slideFromRight,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    super.settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (transitionType) {
      case PageTransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.fade:
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );

      case PageTransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: child,
        );

      case PageTransitionType.rotation:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: curve)),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

/// Route guard mixin for protecting routes
mixin RouteGuard {
  /// Check if user can access the route
  bool canAccess(BuildContext context) => true;

  /// Redirect route if access is denied
  String get redirectRoute => '/';

  /// Custom handling when access is denied
  void onAccessDenied(BuildContext context) {
    // Show snackbar or dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Access denied to this page'),
      ),
    );
  }
}

/// Navigation observer for tracking route changes
class AppNavigationObserver extends NavigatorObserver {
  static final List<Route<dynamic>> _routeStack = [];

  /// Get current route stack
  static List<Route<dynamic>> get routeStack => List.unmodifiable(_routeStack);

  /// Get current route name
  static String? get currentRouteName =>
      _routeStack.isNotEmpty ? _routeStack.last.settings.name : null;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _routeStack.add(route);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _routeStack.remove(route);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      final index = _routeStack.indexOf(oldRoute);
      if (index >= 0 && newRoute != null) {
        _routeStack[index] = newRoute;
      }
    }
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _routeStack.remove(route);
    _logNavigation('REMOVE', route, previousRoute);
  }

  void _logNavigation(
      String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint('📍 Navigation $action: ${route?.settings.name} '
        '(from: ${previousRoute?.settings.name})');
    debugPrint(
        '📚 Route Stack: ${_routeStack.map((r) => r.settings.name).toList()}');
  }
}

/// Navigation analytics for tracking user navigation patterns
class NavigationAnalytics {
  static final Map<String, int> _routeVisits = {};
  static final List<String> _navigationHistory = [];

  /// Track route visit
  static void trackRouteVisit(String routeName) {
    _routeVisits[routeName] = (_routeVisits[routeName] ?? 0) + 1;
    _navigationHistory.add(routeName);

    // Keep only last 100 navigation events
    if (_navigationHistory.length > 100) {
      _navigationHistory.removeAt(0);
    }

    debugPrint(
        '📊 Route visited: $routeName (${_routeVisits[routeName]} times)');
  }

  /// Get most visited routes
  static Map<String, int> get mostVisitedRoutes {
    final sorted = Map.fromEntries(
      _routeVisits.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  /// Get navigation history
  static List<String> get navigationHistory =>
      List.unmodifiable(_navigationHistory);

  /// Clear analytics data
  static void clearAnalytics() {
    _routeVisits.clear();
    _navigationHistory.clear();
  }
}
