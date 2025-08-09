import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomSpinner extends StatefulWidget {
  const CustomSpinner({super.key});

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rotationController.repeat();
    _scaleController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: CustomPaint(
                size: const Size(80, 80),
                painter: SpinnerPainter(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SpinnerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const int segments = 8;
    for (int i = 0; i < segments; i++) {
      final angle = (2 * math.pi * i) / segments;
      final opacity = (i + 1) / segments;

      final paint = Paint()
        ..color = Colors.blue.withOpacity(opacity)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

      final startX = center.dx + (radius - 15) * math.cos(angle);
      final startY = center.dy + (radius - 15) * math.sin(angle);
      final endX = center.dx + radius * math.cos(angle);
      final endY = center.dy + radius * math.sin(angle);

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
