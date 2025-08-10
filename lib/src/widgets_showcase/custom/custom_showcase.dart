import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../common/showcase_card.dart';

class CustomShowcase extends StatelessWidget {
  const CustomShowcase({super.key});

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
            title: 'Custom Widget 1',
            description: 'Description of custom widget 1',
            child: Container(),
          ),
        ],
      ),
    );
  }
}
