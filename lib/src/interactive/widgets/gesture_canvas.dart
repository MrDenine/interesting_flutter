import 'package:flutter/material.dart';

class GestureCanvas extends StatefulWidget {
  const GestureCanvas({super.key});

  @override
  State<GestureCanvas> createState() => _GestureCanvasState();
}

class _GestureCanvasState extends State<GestureCanvas> {
  List<Offset> _points = [];
  String _gestureType = 'None';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _points = [details.localPosition];
                _gestureType = 'Drawing';
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _points.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                _gestureType = 'Finished';
              });
            },
            onTap: () {
              setState(() {
                _gestureType = 'Tap';
                _points.clear();
              });
            },
            onDoubleTap: () {
              setState(() {
                _gestureType = 'Double Tap';
                _points.clear();
              });
            },
            onLongPress: () {
              setState(() {
                _gestureType = 'Long Press';
                _points.clear();
              });
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: CustomPaint(
                painter: GesturePainter(_points),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gesture: $_gestureType',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _points.clear();
                    _gestureType = 'None';
                  });
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GesturePainter extends CustomPainter {
  final List<Offset> points;

  GesturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
