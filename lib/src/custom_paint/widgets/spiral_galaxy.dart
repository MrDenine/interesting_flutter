import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpiralGalaxy extends StatefulWidget {
  const SpiralGalaxy({Key? key}) : super(key: key);

  @override
  State<SpiralGalaxy> createState() => _SpiralGalaxyState();
}

class _SpiralGalaxyState extends State<SpiralGalaxy>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
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
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(125),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: SpiralPainter(_controller.value),
              size: const Size(250, 250),
            );
          },
        ),
      ),
    );
  }
}

class SpiralPainter extends CustomPainter {
  final double animationValue;

  SpiralPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 - 10;

    // Draw spiral arms
    for (int arm = 0; arm < 3; arm++) {
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke;

      final path = Path();
      bool first = true;

      for (double t = 0; t < 6 * math.pi; t += 0.1) {
        final radius = t * maxRadius / (6 * math.pi);
        final angle =
            t + (arm * 2 * math.pi / 3) + (animationValue * 2 * math.pi);
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        if (first) {
          path.moveTo(x, y);
          first = false;
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Draw stars
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final angle = i * 0.3 + animationValue * 2 * math.pi;
      final radius = (i % 10 + 1) * maxRadius / 12;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final starSize = math.Random(i).nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), starSize, starPaint);
    }

    // Draw center
    final centerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.yellow,
          Colors.orange,
          Colors.red.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 20));

    canvas.drawCircle(center, 20, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
