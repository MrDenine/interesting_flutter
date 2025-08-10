import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interesting_flutter/presentation/widgets/common/showcase_card.dart';
import 'package:interesting_flutter/presentation/widgets/loading/shimmer_example.dart';
import 'package:interesting_flutter/presentation/widgets/loading/custom_spinner.dart';
import 'package:interesting_flutter/presentation/widgets/loading/progress_indicators_example.dart';
import 'package:interesting_flutter/presentation/widgets/loading/pulse_loading.dart';

class LoadingWidgetsShowcase extends StatelessWidget {
  const LoadingWidgetsShowcase({super.key});

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
            title: 'Shimmer Effect',
            description: 'Skeleton loading with shimmer animation',
            child: ShimmerExample(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Custom Spinner',
            description: 'Animated custom loading spinner',
            child: CustomSpinner(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Progress Indicators',
            description: 'Various animated progress indicators',
            child: ProgressIndicatorsExample(),
          ),
          SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Pulse Loading',
            description: 'Pulsing animation for loading states',
            child: PulseLoading(),
          ),
        ],
      ),
    );
  }
}
