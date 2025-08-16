import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App theme mode provider
/// Manages the global theme state (light, dark, system)
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// Theme notifier for managing theme state
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  /// Switch to light theme
  void setLightTheme() {
    state = ThemeMode.light;
  }

  /// Switch to dark theme
  void setDarkTheme() {
    state = ThemeMode.dark;
  }

  /// Switch to system theme
  void setSystemTheme() {
    state = ThemeMode.system;
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

/// App loading state provider
/// Manages global loading states for the entire app
final appLoadingProvider =
    StateNotifierProvider<AppLoadingNotifier, AppLoadingState>((ref) {
  return AppLoadingNotifier();
});

/// App loading state model
class AppLoadingState {
  final bool isInitializing;
  final bool isRefreshing;
  final Map<String, bool> loadingStates;

  const AppLoadingState({
    this.isInitializing = false,
    this.isRefreshing = false,
    this.loadingStates = const {},
  });

  AppLoadingState copyWith({
    bool? isInitializing,
    bool? isRefreshing,
    Map<String, bool>? loadingStates,
  }) {
    return AppLoadingState(
      isInitializing: isInitializing ?? this.isInitializing,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      loadingStates: loadingStates ?? this.loadingStates,
    );
  }

  /// Check if any loading state is active
  bool get hasAnyLoading {
    return isInitializing ||
        isRefreshing ||
        loadingStates.values.any((loading) => loading);
  }

  /// Check if a specific loading state is active
  bool isLoading(String key) {
    return loadingStates[key] ?? false;
  }
}

/// App loading notifier for managing global loading states
class AppLoadingNotifier extends StateNotifier<AppLoadingState> {
  AppLoadingNotifier() : super(const AppLoadingState());

  /// Set app initialization loading state
  void setInitializing(bool isLoading) {
    state = state.copyWith(isInitializing: isLoading);
  }

  /// Set app refresh loading state
  void setRefreshing(bool isLoading) {
    state = state.copyWith(isRefreshing: isLoading);
  }

  /// Set a specific loading state
  void setLoading(String key, bool isLoading) {
    final newLoadingStates = Map<String, bool>.from(state.loadingStates);
    if (isLoading) {
      newLoadingStates[key] = true;
    } else {
      newLoadingStates.remove(key);
    }
    state = state.copyWith(loadingStates: newLoadingStates);
  }

  /// Clear all loading states
  void clearAllLoading() {
    state = const AppLoadingState();
  }
}

/// App navigation state provider
/// Manages global navigation state and history
final appNavigationProvider =
    StateNotifierProvider<AppNavigationNotifier, AppNavigationState>((ref) {
  return AppNavigationNotifier();
});

/// App navigation state model
class AppNavigationState {
  final String currentRoute;
  final List<String> routeHistory;
  final Map<String, dynamic> navigationData;

  const AppNavigationState({
    this.currentRoute = '/',
    this.routeHistory = const ['/'],
    this.navigationData = const {},
  });

  AppNavigationState copyWith({
    String? currentRoute,
    List<String>? routeHistory,
    Map<String, dynamic>? navigationData,
  }) {
    return AppNavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      routeHistory: routeHistory ?? this.routeHistory,
      navigationData: navigationData ?? this.navigationData,
    );
  }

  /// Get the previous route
  String? get previousRoute {
    if (routeHistory.length < 2) return null;
    return routeHistory[routeHistory.length - 2];
  }

  /// Check if we can go back
  bool get canGoBack {
    return routeHistory.length > 1;
  }
}

/// App navigation notifier for managing navigation state
class AppNavigationNotifier extends StateNotifier<AppNavigationState> {
  AppNavigationNotifier() : super(const AppNavigationState());

  /// Navigate to a new route
  void navigateTo(String route, {Map<String, dynamic>? data}) {
    final newHistory = List<String>.from(state.routeHistory);
    newHistory.add(route);

    state = state.copyWith(
      currentRoute: route,
      routeHistory: newHistory,
      navigationData: data ?? {},
    );
  }

  /// Go back to previous route
  void goBack() {
    if (!state.canGoBack) return;

    final newHistory = List<String>.from(state.routeHistory);
    newHistory.removeLast();

    state = state.copyWith(
      currentRoute: newHistory.last,
      routeHistory: newHistory,
      navigationData: {},
    );
  }

  /// Replace current route
  void replaceCurrent(String route, {Map<String, dynamic>? data}) {
    final newHistory = List<String>.from(state.routeHistory);
    if (newHistory.isNotEmpty) {
      newHistory[newHistory.length - 1] = route;
    } else {
      newHistory.add(route);
    }

    state = state.copyWith(
      currentRoute: route,
      routeHistory: newHistory,
      navigationData: data ?? {},
    );
  }

  /// Clear navigation history
  void clearHistory() {
    state = AppNavigationState(
      currentRoute: state.currentRoute,
      routeHistory: [state.currentRoute],
      navigationData: state.navigationData,
    );
  }

  /// Set navigation data
  void setNavigationData(Map<String, dynamic> data) {
    state = state.copyWith(navigationData: data);
  }
}
