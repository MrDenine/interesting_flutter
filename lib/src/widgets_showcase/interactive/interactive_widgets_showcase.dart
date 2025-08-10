import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../common/showcase_card.dart';
import 'widgets/draggable_card.dart';
import 'widgets/swipe_to_delete.dart';
import 'widgets/interactive_button.dart';
import 'widgets/gesture_canvas.dart';

class InteractiveWidgetsShowcase extends StatelessWidget {
  const InteractiveWidgetsShowcase({super.key});

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
            title: 'Draggable Card',
            description: 'Card that can be dragged around the screen',
            child: DraggableCard(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Swipe to Delete',
            description: 'Swipe gesture to reveal delete action',
            child: SwipeToDelete(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Interactive Button',
            description: 'Button with ripple effect and scale animation',
            child: InteractiveButton(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Gesture Detector',
            description: 'Multi-touch gesture recognition',
            child: GestureCanvas(),
          ),
        ],
      ),
    );
  }
}
