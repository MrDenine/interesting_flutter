import 'package:flutter/material.dart';

class Neumorphism extends StatefulWidget {
  const Neumorphism({super.key});

  @override
  State<Neumorphism> createState() => _NeumorphismState();
}

class _NeumorphismState extends State<Neumorphism> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: const Center(
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 40,
          ),
        ),
      ),
    );
  }
}
