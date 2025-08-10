import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interesting_flutter/modules/widgets_showcase/widgets/animations/floating_bubbles.dart';
import 'package:interesting_flutter/modules/widgets_showcase/widgets/animations/loading_dots.dart';
import 'package:interesting_flutter/modules/widgets_showcase/widgets/animations/morphing_container.dart';
import 'package:interesting_flutter/modules/widgets_showcase/widgets/animations/pulsing_heart.dart';
import 'package:interesting_flutter/shared/common/showcase_card.dart';

class AnimatedWidgetsShowcase extends StatelessWidget {
  const AnimatedWidgetsShowcase({super.key});

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
            title: 'Pulsing Heart',
            description: 'Animated heart with scale and color transitions',
            child: PulsingHeart(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Floating Bubbles',
            description: 'Animated bubbles floating upward',
            child: FloatingBubbles(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Loading Dots',
            description: 'Sequential animated loading dots',
            child: LoadingDots(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Morphing Container',
            description: 'Container that morphs between different shapes',
            child: MorphingContainer(),
          ),
        ],
      ),
    );
  }
}
