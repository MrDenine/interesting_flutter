import 'package:flutter/foundation.dart';

/// Authentication states
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// User model for authentication
class AuthUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isAnonymous;

  const AuthUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    required this.isAnonymous,
  });

  @override
  String toString() {
    return 'AuthUser(id: $id, email: $email, displayName: $displayName, isAnonymous: $isAnonymous)';
  }
}

/// Authentication result
class AuthResult {
  final bool success;
  final AuthUser? user;
  final String? errorMessage;

  const AuthResult({
    required this.success,
    this.user,
    this.errorMessage,
  });

  factory AuthResult.success(AuthUser user) {
    return AuthResult(success: true, user: user);
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult(success: false, errorMessage: errorMessage);
  }
}

/// Abstract authentication service interface
/// TODO: Implement this with your preferred authentication service (Firebase, Supabase, etc.)
abstract class AuthenticationService extends ChangeNotifier {
  /// Current authentication state
  AuthState get authState;

  /// Current authenticated user (null if not authenticated)
  AuthUser? get currentUser;

  /// Error message if any
  String? get errorMessage;

  /// Check if user is currently authenticated
  bool get isAuthenticated =>
      authState == AuthState.authenticated && currentUser != null;

  /// Check if authentication is in progress
  bool get isLoading => authState == AuthState.loading;

  /// Initialize authentication service
  /// This should check for existing authentication state
  Future<void> initialize();

  /// Sign in with Google
  /// Returns AuthResult with success status and user data or error message
  Future<AuthResult> signInWithGoogle();

  /// Sign in anonymously
  /// Returns AuthResult with success status and user data or error message
  Future<AuthResult> signInAnonymously();

  /// Sign out current user
  /// Clears all authentication data and returns to unauthenticated state
  Future<void> signOut();

  /// Listen to authentication state changes
  /// This should update the authState and currentUser properties
  void listenToAuthChanges();

  /// Dispose resources
  @override
  void dispose();
}

/// TODO: Concrete implementation example
/// You can implement this class with your preferred authentication service
///
/// Example implementation structure:
/// ```dart
/// class FirebaseAuthService extends AuthenticationService {
///   final FirebaseAuth _auth = FirebaseAuth.instance;
///   final GoogleSignIn _googleSignIn = GoogleSignIn();
///
///   AuthState _authState = AuthState.initial;
///   AuthUser? _currentUser;
///   String? _errorMessage;
///
///   @override
///   AuthState get authState => _authState;
///
///   @override
///   AuthUser? get currentUser => _currentUser;
///
///   @override
///   String? get errorMessage => _errorMessage;
///
///   @override
///   Future<void> initialize() async {
///     // Initialize Firebase Auth and check current user
///     listenToAuthChanges();
///     // Check if user is already signed in
///   }
///
///   @override
///   Future<AuthResult> signInWithGoogle() async {
///     try {
///       _updateState(AuthState.loading);
///       // Implement Google Sign-In logic
///       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
///       // ... rest of implementation
///     } catch (e) {
///       _updateState(AuthState.error, errorMessage: e.toString());
///       return AuthResult.failure(e.toString());
///     }
///   }
///
///   // ... other method implementations
/// }
/// ```
class MockAuthService extends AuthenticationService {
  AuthState _authState = AuthState.initial;
  AuthUser? _currentUser;
  String? _errorMessage;

  @override
  AuthState get authState => _authState;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  String? get errorMessage => _errorMessage;

  void _updateState(AuthState newState,
      {AuthUser? user, String? errorMessage}) {
    _authState = newState;
    _currentUser = user;
    _errorMessage = errorMessage;
    notifyListeners();
  }

  @override
  Future<void> initialize() async {
    // Mock initialization
    _updateState(AuthState.unauthenticated);
  }

  @override
  Future<AuthResult> signInWithGoogle() async {
    try {
      _updateState(AuthState.loading);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful Google sign-in
      final user = AuthUser(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com',
        displayName: 'Google User',
        photoUrl: 'https://example.com/avatar.jpg',
        isAnonymous: false,
      );

      _updateState(AuthState.authenticated, user: user);
      return AuthResult.success(user);
    } catch (e) {
      _updateState(AuthState.error, errorMessage: e.toString());
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<AuthResult> signInAnonymously() async {
    try {
      _updateState(AuthState.loading);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful anonymous sign-in
      final user = AuthUser(
        id: 'anon_${DateTime.now().millisecondsSinceEpoch}',
        email: null,
        displayName: 'Guest User',
        photoUrl: null,
        isAnonymous: true,
      );

      _updateState(AuthState.authenticated, user: user);
      return AuthResult.success(user);
    } catch (e) {
      _updateState(AuthState.error, errorMessage: e.toString());
      return AuthResult.failure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    _updateState(AuthState.loading);

    // Simulate sign out delay
    await Future.delayed(const Duration(milliseconds: 500));

    _updateState(AuthState.unauthenticated);
  }

  @override
  void listenToAuthChanges() {
    // Mock implementation - in real app, this would listen to auth service changes
  }
}
