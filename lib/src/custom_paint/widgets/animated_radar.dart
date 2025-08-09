import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedRadar extends StatefulWidget {
  const AnimatedRadar({super.key});

  @override
  State<AnimatedRadar> createState() => _AnimatedRadarState();
}

class _AnimatedRadarState extends State<AnimatedRadar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: RadarPainter(_controller.value),
              size: const Size(200, 200),
            );
          },
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double animationValue;

  RadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw circles
    for (int i = 1; i <= 4; i++) {
      paint.color = Colors.green.withOpacity(0.3);
      canvas.drawCircle(center, radius * i / 4, paint);
    }

    // Draw cross lines
    paint.color = Colors.green.withOpacity(0.5);
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );

    // Draw rotating sweep
    final sweepPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.green.withOpacity(0.8),
          Colors.green.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    final sweepAngle = animationValue * 2 * math.pi;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(sweepAngle);
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      -math.pi / 6,
      math.pi / 3,
      true,
      sweepPaint,
    );
    canvas.restore();

    // Draw blips
    for (int i = 0; i < 5; i++) {
      final blipAngle = (i * 0.4 + animationValue * 2) * math.pi;
      final blipRadius = radius * (0.3 + (i * 0.15));
      final blipX = center.dx + math.cos(blipAngle) * blipRadius;
      final blipY = center.dy + math.sin(blipAngle) * blipRadius;

      final blipPaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(blipX, blipY), 3, blipPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
