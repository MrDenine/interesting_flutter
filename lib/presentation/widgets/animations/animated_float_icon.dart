import 'package:flutter/material.dart';

class AnimateFloatIcon extends StatelessWidget {
  final IconData icon;
  final double delay;
  final AnimationController progressController;
  final Animation<double> progressAnimation;

  const AnimateFloatIcon({
    super.key,
    required this.icon,
    required this.delay,
    required this.progressController,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressController,
      builder: (context, child) {
        double animationValue =
            (progressAnimation.value - delay).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -10 * animationValue),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
