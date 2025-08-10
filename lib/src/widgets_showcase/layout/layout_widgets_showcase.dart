import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../common/showcase_card.dart';
import 'widgets/staggered_grid_example.dart';
import 'widgets/parallax_scroll_example.dart';
import 'widgets/expansion_panels_example.dart';
import 'widgets/flow_layout_example.dart';

class LayoutWidgetsShowcase extends StatelessWidget {
  const LayoutWidgetsShowcase({super.key});

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
            title: 'Staggered Grid',
            description: 'Pinterest-style staggered grid layout',
            child: StaggeredGridExample(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Parallax Scroll',
            description: 'Parallax scrolling effect with layers',
            child: ParallaxScrollExample(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Expansion Panels',
            description: 'Accordion-style expandable panels',
            child: ExpansionPanelsExample(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Flow Layout',
            description: 'Dynamic flow layout with wrap',
            child: FlowLayoutExample(),
          ),
        ],
      ),
    );
  }
}
