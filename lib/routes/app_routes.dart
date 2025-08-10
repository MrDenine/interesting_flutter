import 'package:flutter/material.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/widget_detail_screen.dart';
import '../data/models/widget_category.dart';
import '../core/services/navigation/navigation_service.dart';

/// App route names as constants for type safety
class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String widgetDetail = '/widget-detail';

  /// Private constructor to prevent instantiation
  AppRoutes._();
}

/// Route generator for handling all app navigation
class AppRouteGenerator {
  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _createRoute(
          const SplashScreen(),
          settings: settings,
        );

      case AppRoutes.home:
        return _createRoute(
          const HomeScreen(),
          settings: settings,
        );

      case AppRoutes.widgetDetail:
        final category = settings.arguments as WidgetCategory?;
        if (category == null) {
          return _createErrorRoute('Widget category is required');
        }
        return _createRoute(
          WidgetDetailScreen(category: category),
          settings: settings,
        );

      default:
        return _createErrorRoute('Route not found: ${settings.name}');
    }
  }

  /// Create a custom page route with slide transition
  static PageRoute _createRoute(
    Widget child, {
    required RouteSettings settings,
    Duration transitionDuration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: transitionDuration,
      reverseTransitionDuration: transitionDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Create error route for unknown routes
  static PageRoute _createErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Page Not Found',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    _,
                    AppRoutes.home,
                    (route) => false,
                  ),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigation helper methods
class AppNavigator {
  /// Navigate to home screen and clear stack
  static Future<void> goHome(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
    );
  }

  /// Navigate to widget detail screen
  static Future<void> goToWidgetDetail(
    BuildContext context,
    WidgetCategory category,
  ) {
    return Navigator.pushNamed(
      context,
      AppRoutes.widgetDetail,
      arguments: category,
    );
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /// Replace current route with new route
  static Future<void> pushReplacement(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  /// Global navigation methods (using NavigationService)

  /// Navigate to home screen globally
  static Future<void> goHomeGlobal() {
    final navigationService = NavigationService.instance;
    return navigationService.navigateAndClear(AppRoutes.home);
  }

  /// Navigate to widget detail screen globally
  static Future<void> goToWidgetDetailGlobal(WidgetCategory category) {
    final navigationService = NavigationService.instance;
    return navigationService.navigateTo(
      AppRoutes.widgetDetail,
      arguments: category,
    );
  }

  /// Go back globally
  static void goBackGlobal<T extends Object?>([T? result]) {
    final navigationService = NavigationService.instance;
    navigationService.goBack<T>(result);
  }

  /// Show snackbar globally
  static void showSnackBar(String message, {Duration? duration}) {
    final navigationService = NavigationService.instance;
    navigationService.showSnackBar(message, duration: duration);
  }
}
