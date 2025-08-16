class LoginState {
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isAnonymousLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool hasNavigated;

  const LoginState({
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isAnonymousLoading = false,
    this.errorMessage,
    this.successMessage,
    this.hasNavigated = false,
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isGoogleLoading,
    bool? isAnonymousLoading,
    String? errorMessage,
    String? successMessage,
    bool? hasNavigated,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isGoogleLoading: isGoogleLoading ?? this.isGoogleLoading,
      isAnonymousLoading: isAnonymousLoading ?? this.isAnonymousLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      hasNavigated: hasNavigated ?? this.hasNavigated,
    );
  }

  /// Clear error and success messages
  LoginState clearMessages() {
    return copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isGoogleLoading == other.isGoogleLoading &&
          isAnonymousLoading == other.isAnonymousLoading &&
          errorMessage == other.errorMessage &&
          successMessage == other.successMessage &&
          hasNavigated == other.hasNavigated;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      isGoogleLoading.hashCode ^
      isAnonymousLoading.hashCode ^
      errorMessage.hashCode ^
      successMessage.hashCode ^
      hasNavigated.hashCode;

  @override
  String toString() {
    return 'LoginState{isLoading: $isLoading, isGoogleLoading: $isGoogleLoading, isAnonymousLoading: $isAnonymousLoading, errorMessage: $errorMessage, successMessage: $successMessage, hasNavigated: $hasNavigated}';
  }
}
