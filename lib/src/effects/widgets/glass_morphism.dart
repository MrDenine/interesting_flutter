import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background with gradient
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        // Glass effect overlay
        Positioned(
          top: 20,
          left: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 160,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.apps,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Glass Effect',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
