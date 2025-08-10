import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../common/showcase_card.dart';
import 'widgets/gradient_effects.dart';
import 'widgets/glass_morphism.dart';
import 'widgets/neumorphism.dart';
import 'widgets/neon_glow.dart';

class VisualEffectsShowcase extends StatelessWidget {
  const VisualEffectsShowcase({super.key});

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
            title: 'Gradient Effects',
            description: 'Beautiful gradient animations and effects',
            child: GradientEffects(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Glass Morphism',
            description: 'Frosted glass effect with blur',
            child: GlassMorphism(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Neumorphism',
            description: 'Soft UI design with inner/outer shadows',
            child: Neumorphism(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Neon Glow',
            description: 'Glowing neon effect with animation',
            child: NeonGlow(),
          ),
        ],
      ),
    );
  }
}
