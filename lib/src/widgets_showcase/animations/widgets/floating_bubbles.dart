import 'package:flutter/material.dart';

class FloatingBubbles extends StatefulWidget {
  const FloatingBubbles({super.key});

  @override
  State<FloatingBubbles> createState() => _FloatingBubblesState();
}

class _FloatingBubblesState extends State<FloatingBubbles>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
      (index) => AnimationController(
        duration: Duration(milliseconds: 2000 + (index * 300)),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Stack(
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Positioned(
                left: 20.0 + (index * 30),
                bottom: _animations[index].value * 80,
                child: Opacity(
                  opacity: 1.0 - _animations[index].value,
                  child: Container(
                    width: 20 + (index * 2),
                    height: 20 + (index * 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
