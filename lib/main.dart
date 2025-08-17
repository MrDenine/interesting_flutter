import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_transitions.dart';
import 'core/services/navigation/navigation_service.dart';

void main() {
  runApp(const InterestingFlutterApp());
}

class InterestingFlutterApp extends StatelessWidget {
  const InterestingFlutterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interesting Flutter Widgets',
      debugShowCheckedModeBanner: false,
      // Add navigation key for global navigation service
      navigatorKey: NavigationService.instance.navigatorKey,
      // Add navigation observers for tracking
      navigatorObservers: [
        AppNavigationObserver(),
      ],
      // Use named routes instead of home
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouteGenerator.generateRoute,
      // Handle unknown routes
      onUnknownRoute: (settings) => AppRouteGenerator.generateRoute(
        RouteSettings(name: '/error', arguments: settings.arguments),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
    );
  }
}
