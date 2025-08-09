import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../common/showcase_card.dart';
import 'widgets/animated_text_fields.dart';
import 'widgets/custom_switches.dart';
import 'widgets/range_slider_example.dart';
import 'widgets/rating_widget.dart';

class FormControlsShowcase extends StatelessWidget {
  const FormControlsShowcase({super.key});

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
            title: 'Animated Text Fields',
            description: 'Text fields with smooth animations',
            child: AnimatedTextFields(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Custom Switches',
            description: 'Beautiful animated toggle switches',
            child: CustomSwitches(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Range Slider',
            description: 'Dual-handle range slider',
            child: RangeSliderExample(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Rating Widget',
            description: 'Interactive star rating component',
            child: RatingWidget(),
          ),
        ],
      ),
    );
  }
}
