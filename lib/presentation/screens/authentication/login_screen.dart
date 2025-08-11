import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/authentication/auth_service.dart';
import '../../widgets/common/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // TODO: Replace with your preferred authentication service implementation
  // For now using mock service for demonstration
  late AuthenticationService _authService;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeAuthService();
  }

  void _initializeAuthService() {
    // TODO: Replace MockAuthService with your actual implementation
    // Example: _authService = FirebaseAuthService();
    _authService = MockAuthService();
    _authService.addListener(_onAuthStateChanged);
    _authService.initialize();
  }

  void _onAuthStateChanged() {
    if (!mounted) return;

    // Handle authentication state changes
    switch (_authService.authState) {
      case AuthState.authenticated:
        // User successfully authenticated, navigate to home
        if (_authService.currentUser != null) {
          AppNavigator.goHome(context);
        }
        break;
      case AuthState.error:
        // Show error message
        if (_authService.errorMessage != null) {
          _showSnackBar(_authService.errorMessage!, isSuccess: false);
        }
        break;
      case AuthState.loading:
        // Update loading state
        setState(() => _isLoading = true);
        break;
      case AuthState.unauthenticated:
      case AuthState.initial:
        // Update loading state
        setState(() => _isLoading = false);
        break;
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authService.removeListener(_onAuthStateChanged);
    _authService.dispose();
    super.dispose();
  }

  // Handle Google Sign-In using authentication service
  Future<void> _handleGoogleSignIn() async {
    try {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Use authentication service for Google Sign-In
      final result = await _authService.signInWithGoogle();

      if (result.success && result.user != null) {
        // Success feedback will be shown via state listener
        // Navigation will be handled in _onAuthStateChanged
        _showSnackBar('Google Sign-In successful!', isSuccess: true);
      } else {
        // Error will be handled via state listener
        _showSnackBar(
          result.errorMessage ?? 'Google Sign-In failed. Please try again.',
          isSuccess: false,
        );
      }
    } catch (e) {
      _showSnackBar('An unexpected error occurred.', isSuccess: false);
    }
  }

  // Handle Anonymous Sign-In using authentication service
  Future<void> _handleAnonymousSignIn() async {
    try {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Use authentication service for Anonymous Sign-In
      final result = await _authService.signInAnonymously();

      if (result.success && result.user != null) {
        // Success feedback will be shown via state listener
        // Navigation will be handled in _onAuthStateChanged
        _showSnackBar('Signed in as guest!', isSuccess: true);
      } else {
        // Error will be handled via state listener
        _showSnackBar(
          result.errorMessage ?? 'Anonymous sign-in failed. Please try again.',
          isSuccess: false,
        );
      }
    } catch (e) {
      _showSnackBar('An unexpected error occurred.', isSuccess: false);
    }
  }

  void _showSnackBar(String message, {required bool isSuccess}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              Theme.of(context).colorScheme.secondary,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          // header
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // App Logo/Icon
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.flutter_dash,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Welcome Text
                              Text(
                                'Welcome to',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Interesting Flutter',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Discover amazing Flutter widgets and explore powerful features',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      height: 1.3,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Login Options
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Sign-In Button
                              LoginButton.google(
                                onPressed:
                                    (_isLoading || _authService.isLoading)
                                        ? null
                                        : _handleGoogleSignIn,
                                context: context,
                              ),

                              const SizedBox(height: 16),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'or',
                                      style: TextStyle(
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Anonymous Sign-In Button
                              LoginButton.anonymous(
                                onPressed:
                                    (_isLoading || _authService.isLoading)
                                        ? null
                                        : _handleAnonymousSignIn,
                              ),

                              const SizedBox(height: 32),

                              // Loading Indicator
                              if (_isLoading || _authService.isLoading)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white.withValues(alpha: 0.8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Signing you in...',
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Footer
                        Column(
                          children: [
                            Text(
                              'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Skip for now option
                            TextButton(
                              onPressed: () => AppNavigator.goHome(context),
                              child: Text(
                                'Skip for now',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
