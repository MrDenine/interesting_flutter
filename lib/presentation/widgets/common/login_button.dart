import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final bool hasBorder;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.hasBorder = false,
  });

  /// Factory constructor for Google Sign-In button
  factory LoginButton.google({
    required VoidCallback? onPressed,
    required BuildContext context,
  }) {
    return LoginButton(
      onPressed: onPressed,
      icon: Icons.account_circle,
      text: 'Continue with Google',
      backgroundColor: Colors.white,
      textColor: Theme.of(context).colorScheme.primary,
      iconColor: Theme.of(context).colorScheme.primary,
      hasBorder: false,
    );
  }

  /// Factory constructor for Anonymous Sign-In button
  factory LoginButton.anonymous({
    required VoidCallback? onPressed,
  }) {
    return LoginButton(
      onPressed: onPressed,
      icon: Icons.person_outline,
      text: 'Continue as Guest',
      backgroundColor: Colors.transparent,
      textColor: Colors.white,
      iconColor: Colors.white,
      hasBorder: true,
    );
  }

  /// Factory constructor for custom branded buttons
  factory LoginButton.custom({
    required VoidCallback? onPressed,
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color textColor,
    Color? iconColor,
    bool hasBorder = false,
  }) {
    return LoginButton(
      onPressed: onPressed,
      icon: icon,
      text: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor ?? textColor,
      hasBorder: hasBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: hasBorder ? 0 : 8,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: hasBorder
                ? BorderSide(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  )
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return (hasBorder ? Colors.white : textColor)
                    .withValues(alpha: 0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return (hasBorder ? Colors.white : textColor)
                    .withValues(alpha: 0.05);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
