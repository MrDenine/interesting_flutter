import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interesting_flutter/src/common/showcase_card.dart';
import 'package:interesting_flutter/src/maps_location/widgets/basic_flutter_map.dart';
import 'package:interesting_flutter/src/maps_location/widgets/interactive_map.dart';
import 'package:interesting_flutter/src/maps_location/widgets/custom_markers_map.dart';

class MapsLocationShowcase extends StatelessWidget {
  const MapsLocationShowcase({super.key});

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
          AnimatedShowcaseCard(
            title: 'Basic Flutter Map',
            description: 'Interactive map with markers and polylines',
            child: const BasicFlutterMapExample(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Interactive Distance Measurement',
            description: 'Tap to measure distances between points',
            child: const InteractiveMapExample(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Custom Markers',
            description: 'Animated custom markers with detailed info',
            child: const CustomMarkersMapExample(),
          ),
        ],
      ),
    );
  }
}
