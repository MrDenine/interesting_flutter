import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/authentication/auth_service.dart';
import 'login_state.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  final AuthenticationService _authService;

  LoginNotifier(this._authService) : super(const LoginState());

  /// Handle Google Sign-In
  Future<void> signInWithGoogle() async {
    if (state.isLoading || state.isGoogleLoading) return;

    state = state.copyWith(
      isGoogleLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final result = await _authService.signInWithGoogle();

      if (result.success && result.user != null) {
        state = state.copyWith(
          isGoogleLoading: false,
          successMessage: 'Google Sign-In successful!',
        );
      } else {
        state = state.copyWith(
          isGoogleLoading: false,
          errorMessage:
              result.errorMessage ?? 'Google Sign-In failed. Please try again.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isGoogleLoading: false,
        errorMessage: 'An unexpected error occurred during Google Sign-In.',
      );
    }
  }

  /// Handle Anonymous Sign-In
  Future<void> signInAnonymously() async {
    if (state.isLoading || state.isAnonymousLoading) return;

    state = state.copyWith(
      isAnonymousLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final result = await _authService.signInAnonymously();

      if (result.success && result.user != null) {
        state = state.copyWith(
          isAnonymousLoading: false,
          successMessage: 'Signed in as guest!',
        );
      } else {
        state = state.copyWith(
          isAnonymousLoading: false,
          errorMessage: result.errorMessage ??
              'Anonymous sign-in failed. Please try again.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isAnonymousLoading: false,
        errorMessage: 'An unexpected error occurred during anonymous sign-in.',
      );
    }
  }

  /// Clear error and success messages
  void clearMessages() {
    state = state.clearMessages();
  }

  /// Mark that navigation has occurred
  void markNavigated() {
    state = state.copyWith(hasNavigated: true);
  }

  /// Reset navigation state
  void resetNavigation() {
    state = state.copyWith(hasNavigated: false);
  }
}
