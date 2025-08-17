import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/app_routes.dart';
import '../../providers/authentication/login_provider.dart';
import '../../widgets/common/login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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
    super.dispose();
  }

  // Handle Google Sign-In using Riverpod providers
  Future<void> _handleGoogleSignIn() async {
    try {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Use Riverpod login provider
      await ref.read(loginStateProvider.notifier).signInWithGoogle();
    } catch (e) {
      _showSnackBar('An unexpected error occurred.', isSuccess: false);
    }
  }

  // Handle Anonymous Sign-In using Riverpod providers
  Future<void> _handleAnonymousSignIn() async {
    try {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Use Riverpod login provider
      await ref.read(loginStateProvider.notifier).signInAnonymously();
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
    // Watch Riverpod providers for reactive state management
    final isLoginLoading = ref.watch(isLoginLoadingProvider);

    // Listen for authentication success and navigate
    ref.listen<bool>(shouldNavigateProvider, (previous, shouldNavigate) {
      if (shouldNavigate) {
        ref.read(loginStateProvider.notifier).markNavigated();
        AppNavigator.goHome(context);
      }
    });

    // Listen for login error messages
    ref.listen<String?>(loginErrorProvider, (previous, errorMessage) {
      if (errorMessage != null) {
        _showSnackBar(errorMessage, isSuccess: false);
        // Clear the error message after showing
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ref.read(loginStateProvider.notifier).clearMessages();
          }
        });
      }
    });

    // Listen for login success messages
    ref.listen<String?>(loginSuccessProvider, (previous, successMessage) {
      if (successMessage != null) {
        _showSnackBar(successMessage, isSuccess: true);
        // Clear the success message after showing
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            ref.read(loginStateProvider.notifier).clearMessages();
          }
        });
      }
    });

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
                                    isLoginLoading ? null : _handleGoogleSignIn,
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
                                onPressed: isLoginLoading
                                    ? null
                                    : _handleAnonymousSignIn,
                              ),

                              const SizedBox(height: 32),

                              // Loading Indicator
                              if (isLoginLoading)
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
