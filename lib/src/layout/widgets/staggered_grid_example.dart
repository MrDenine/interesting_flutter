import 'package:flutter/material.dart';

class StaggeredGridExample extends StatelessWidget {
  const StaggeredGridExample({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red.withValues(alpha: 0.7),
      Colors.blue.withValues(alpha: 0.7),
      Colors.green.withValues(alpha: 0.7),
      Colors.orange.withValues(alpha: 0.7),
      Colors.purple.withValues(alpha: 0.7),
      Colors.teal.withValues(alpha: 0.7),
    ];

    final heights = [80.0, 120.0, 100.0, 140.0, 90.0, 110.0];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(6, (index) {
          return Container(
            width: (MediaQuery.of(context).size.width - 80) / 2,
            height: heights[index % heights.length],
            decoration: BoxDecoration(
              color: colors[index % colors.length],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Item ${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
