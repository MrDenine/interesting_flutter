import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/authentication/auth_provider.dart';
import 'login_notifier.dart';
import 'login_state.dart';

final loginStateProvider =
    StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return LoginNotifier(authService);
});

/// Provider for checking if any login action is in progress
final isLoginLoadingProvider = Provider<bool>((ref) {
  final loginState = ref.watch(loginStateProvider);
  return loginState.isLoading ||
      loginState.isGoogleLoading ||
      loginState.isAnonymousLoading;
});

/// Provider for login error message
final loginErrorProvider = Provider<String?>((ref) {
  final loginState = ref.watch(loginStateProvider);
  return loginState.errorMessage;
});

/// Provider for login success message
final loginSuccessProvider = Provider<String?>((ref) {
  final loginState = ref.watch(loginStateProvider);
  return loginState.successMessage;
});

/// Provider for checking if Google Sign-In is loading
final isGoogleSignInLoadingProvider = Provider<bool>((ref) {
  final loginState = ref.watch(loginStateProvider);
  return loginState.isGoogleLoading;
});

/// Provider for checking if Anonymous Sign-In is loading
final isAnonymousSignInLoadingProvider = Provider<bool>((ref) {
  final loginState = ref.watch(loginStateProvider);
  return loginState.isAnonymousLoading;
});

/// Provider for checking if navigation should occur
final shouldNavigateProvider = Provider<bool>((ref) {
  final authStatus = ref.watch(authStatusProvider);
  final loginState = ref.watch(loginStateProvider);

  return authStatus.isAuthenticated && !loginState.hasNavigated;
});
