import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interesting_flutter/src/common/showcase_card.dart';
import 'package:interesting_flutter/src/data_display/widgets/animated_chart.dart';
import 'package:interesting_flutter/src/data_display/widgets/animated_line_chart.dart';
import 'package:interesting_flutter/src/data_display/widgets/animated_pie_chart.dart';
import 'package:interesting_flutter/src/data_display/widgets/data_table.dart';
import 'package:interesting_flutter/src/data_display/widgets/statistics_cards.dart';

class DataDisplayShowcase extends StatelessWidget {
  const DataDisplayShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 375),
        childAnimationBuilder: (widget) => SlideAnimation(
          horizontalOffset: 50.0,
          child: FadeInAnimation(child: widget),
        ),
        children: [
          const AnimatedShowcaseCard(
            title: 'Bar Chart',
            description: 'Animated bar chart with elastic animation',
            child: AnimatedChart(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Pie Chart',
            description: 'Interactive pie chart with rotation and legends',
            child: AnimatedPieChart(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Line Chart',
            description:
                'Smooth line chart with gradient fill and animated drawing',
            child: AnimatedLineChart(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Statistics Cards',
            description: 'Animated metric cards with trending indicators',
            child: StatisticsCards(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Data Table',
            description: 'Sortable data table with hover effects and styling',
            child: AnimatedDataTable(),
          ),
        ],
      ),
    );
  }
}
