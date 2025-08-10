import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../shared/common/showcase_card.dart';
import 'animated_radar.dart';
import 'wave_animation.dart';
import 'spiral_galaxy.dart';
import 'progress_ring.dart';

class CustomPaintShowcase extends StatelessWidget {
  const CustomPaintShowcase({super.key});

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
        children: const [
          AnimatedShowcaseCard(
            title: 'Animated Radar',
            description: 'Rotating radar sweep with circular grid',
            child: AnimatedRadar(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Wave Animation',
            description: 'Sine wave with smooth animation',
            child: WaveAnimation(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Spiral Galaxy',
            description: 'Animated spiral with particles',
            child: SpiralGalaxy(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Progress Ring',
            description: 'Circular progress indicator with gradient',
            child: ProgressRing(),
          ),
        ],
      ),
    );
  }
}
