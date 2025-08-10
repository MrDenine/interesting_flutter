import 'package:flutter/material.dart';

class GradientEffects extends StatefulWidget {
  const GradientEffects({super.key});

  @override
  State<GradientEffects> createState() => _GradientEffectsState();
}

class _GradientEffectsState extends State<GradientEffects>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
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
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Linear gradient
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(Colors.red, Colors.blue, _animation.value)!,
                    Color.lerp(Colors.blue, Colors.green, _animation.value)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Radial gradient
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.lerp(Colors.yellow, Colors.purple, _animation.value)!,
                    Color.lerp(Colors.orange, Colors.pink, _animation.value)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Sweep gradient
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    Color.lerp(Colors.cyan, Colors.red, _animation.value)!,
                    Color.lerp(Colors.purple, Colors.orange, _animation.value)!,
                    Color.lerp(Colors.green, Colors.blue, _animation.value)!,
                    Color.lerp(Colors.cyan, Colors.red, _animation.value)!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        );
      },
    );
  }
}
