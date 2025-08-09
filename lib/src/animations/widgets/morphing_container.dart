import 'package:flutter/material.dart';

class MorphingContainer extends StatefulWidget {
  const MorphingContainer({super.key});

  @override
  State<MorphingContainer> createState() => _MorphingContainerState();
}

class _MorphingContainerState extends State<MorphingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _borderRadiusAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _borderRadiusAnimation = Tween<double>(
      begin: 8.0,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _sizeAnimation = Tween<double>(
      begin: 60.0,
      end: 100.0,
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
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: _sizeAnimation.value,
          height: _sizeAnimation.value,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: BorderRadius.circular(_borderRadiusAnimation.value),
            boxShadow: [
              BoxShadow(
                color: (_colorAnimation.value ?? Colors.blue)
                    .withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
