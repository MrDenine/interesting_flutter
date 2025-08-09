import 'package:flutter/material.dart';

class NeonGlow extends StatefulWidget {
  const NeonGlow({super.key});

  @override
  State<NeonGlow> createState() => _NeonGlowState();
}

class _NeonGlowState extends State<NeonGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.3,
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 200,
          height: 150,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.cyan.withValues(alpha: _animation.value),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.cyan.withValues(alpha: _animation.value * 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color:
                        Colors.cyan.withValues(alpha: _animation.value * 0.3),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Text(
                'NEON',
                style: TextStyle(
                  color: Colors.cyan.withValues(alpha: _animation.value),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.cyan.withOpacity(_animation.value),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
