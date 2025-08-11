import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

/// Provider for the authentication service
/// This provides the singleton instance of AuthenticationService
final authServiceProvider = Provider<AuthenticationService>((ref) {
  // TODO: Replace with your actual implementation (e.g., FirebaseAuthService)
  final authService = MockAuthService();

  // Initialize the service when the provider is created
  authService.initialize();

  // Clean up when the provider is disposed
  ref.onDispose(() {
    authService.dispose();
  });

  return authService;
});

/// Provider for the current authentication state
/// This listens to auth state changes and provides reactive updates
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);

  // Return a stream that emits auth state changes
  return Stream<AuthState>.periodic(
    const Duration(milliseconds: 100),
    (_) => authService.authState,
  ).distinct();
});

/// Provider for the current user
/// Returns null if user is not authenticated
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentUser;
});

/// Provider for checking if authentication is in loading state
final authLoadingProvider = Provider<bool>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.isLoading;
});

/// Provider for authentication error message
final authErrorProvider = Provider<String?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.errorMessage;
});

/// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state == AuthState.authenticated,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for authentication status with user data
final authStatusProvider = Provider<AuthStatus>((ref) {
  final authState = ref.watch(authStateProvider);
  final currentUser = ref.watch(currentUserProvider);
  final isLoading = ref.watch(authLoadingProvider);
  final errorMessage = ref.watch(authErrorProvider);

  return authState.when(
    data: (state) => AuthStatus(
      state: state,
      user: currentUser,
      isLoading: isLoading,
      errorMessage: errorMessage,
    ),
    loading: () => AuthStatus(
      state: AuthState.loading,
      user: null,
      isLoading: true,
      errorMessage: null,
    ),
    error: (error, _) => AuthStatus(
      state: AuthState.error,
      user: null,
      isLoading: false,
      errorMessage: error.toString(),
    ),
  );
});

/// Model class to represent authentication status
class AuthStatus {
  final AuthState state;
  final AuthUser? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthStatus({
    required this.state,
    required this.user,
    required this.isLoading,
    required this.errorMessage,
  });

  bool get isAuthenticated => state == AuthState.authenticated && user != null;
  bool get hasError => errorMessage != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthStatus &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          user == other.user &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      state.hashCode ^
      user.hashCode ^
      isLoading.hashCode ^
      errorMessage.hashCode;

  @override
  String toString() {
    return 'AuthStatus{state: $state, user: $user, isLoading: $isLoading, errorMessage: $errorMessage}';
  }
}
