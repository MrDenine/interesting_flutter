import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedLineChart extends StatefulWidget {
  const AnimatedLineChart({super.key});

  @override
  State<AnimatedLineChart> createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<ChartPoint> _data = [
    ChartPoint(0, 20),
    ChartPoint(1, 35),
    ChartPoint(2, 25),
    ChartPoint(3, 45),
    ChartPoint(4, 30),
    ChartPoint(5, 55),
    ChartPoint(6, 40),
    ChartPoint(7, 65),
    ChartPoint(8, 50),
    ChartPoint(9, 70),
  ];

  final List<String> _labels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: LineChartPainter(_data, _animation.value),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _labels
                      .take((_labels.length * _animation.value).ceil())
                      .map((label) {
                    return Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.trending_up, color: Colors.blue, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Revenue Growth',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChartPoint {
  final double x;
  final double y;

  ChartPoint(this.x, this.y);
}

class LineChartPainter extends CustomPainter {
  final List<ChartPoint> data;
  final double animationValue;

  LineChartPainter(this.data, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.withValues(alpha: 0.3),
          Colors.blue.withValues(alpha: 0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    const gridLines = 5;
    for (int i = 0; i <= gridLines; i++) {
      final y = (size.height / gridLines) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Find min and max values
    final maxY = data.map((p) => p.y).reduce(math.max);
    final minY = data.map((p) => p.y).reduce(math.min);
    final range = maxY - minY;

    // Calculate animated data points
    final animatedLength = (data.length * animationValue).floor();
    if (animatedLength == 0) return;

    final animatedData = data.take(animatedLength).toList();
    if (animationValue < 1.0 && animatedLength < data.length) {
      final nextPoint = data[animatedLength];
      final prevPoint =
          animatedLength > 0 ? data[animatedLength - 1] : nextPoint;
      final progress = (data.length * animationValue) - animatedLength;

      animatedData.add(ChartPoint(
        prevPoint.x + (nextPoint.x - prevPoint.x) * progress,
        prevPoint.y + (nextPoint.y - prevPoint.y) * progress,
      ));
    }

    // Convert data points to screen coordinates
    final points = animatedData.map((point) {
      final x = (point.x / (data.length - 1)) * size.width;
      final y = size.height - ((point.y - minY) / range) * size.height;
      return Offset(x, y);
    }).toList();

    if (points.length < 2) return;

    // Draw gradient fill
    final path = Path();
    path.moveTo(points.first.dx, size.height);
    for (final point in points) {
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(points.last.dx, size.height);
    path.close();
    canvas.drawPath(path, gradientPaint);

    // Draw line
    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final current = points[i];
      final previous = points[i - 1];

      // Create smooth curves
      final controlPoint1 = Offset(
        previous.dx + (current.dx - previous.dx) * 0.3,
        previous.dy,
      );
      final controlPoint2 = Offset(
        current.dx - (current.dx - previous.dx) * 0.3,
        current.dy,
      );

      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        current.dx,
        current.dy,
      );
    }
    canvas.drawPath(linePath, paint);

    // Draw points
    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      // Outer white border
      canvas.drawCircle(point, 6, pointBorderPaint);
      // Inner colored circle
      canvas.drawCircle(point, 4, pointPaint);

      // Animated pulse effect for the last point
      if (i == points.length - 1 && animationValue > 0.5) {
        final pulseValue =
            (math.sin((animationValue - 0.5) * 4 * math.pi) + 1) / 2;
        final pulsePaint = Paint()
          ..color = Colors.blue.withOpacity(0.3 * pulseValue)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(point, 8 + pulseValue * 4, pulsePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
