import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerExample extends StatelessWidget {
  const ShimmerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Content lines
          Container(
            width: double.infinity,
            height: 14,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 14,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 14,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          // Image placeholder
          Container(
            width: double.infinity,
            height: 120,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
