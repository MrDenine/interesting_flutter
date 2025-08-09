import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedPieChart extends StatefulWidget {
  const AnimatedPieChart({super.key});

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  final List<ChartData> _data = [
    ChartData('Mobile', 35, Colors.blue),
    ChartData('Desktop', 28, Colors.green),
    ChartData('Tablet', 20, Colors.orange),
    ChartData('Smart TV', 12, Colors.purple),
    ChartData('Other', 5, Colors.red),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _controller.forward();
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_animation, _rotationAnimation]),
      builder: (context, child) {
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 0.1, // Slow rotation
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: PieChartPainter(_data, _animation.value),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Device Usage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: _data.map((data) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: data.color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data.label,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Text(
                                    '${data.value}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}

class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double animationValue;

  PieChartPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    double startAngle = -math.pi / 2; // Start from top

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].value / total) * 2 * math.pi * animationValue;

      final paint = Paint()
        ..color = data[i].color
        ..style = PaintingStyle.fill;

      final shadowPaint = Paint()
        ..color = data[i].color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      // Draw shadow
      canvas.drawArc(
        Rect.fromCircle(center: center + const Offset(2, 2), radius: radius),
        startAngle,
        sweepAngle,
        true,
        shadowPaint,
      );

      // Draw main arc
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, centerPaint);

    // Draw center border
    final centerBorderPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius * 0.4, centerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
