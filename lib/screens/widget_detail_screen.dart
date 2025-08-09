import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interesting_flutter/src/animations/animated_widgets_showcase.dart';

import '../models/widget_category.dart';
import '../src/custom_paint/custom_paint_showcase.dart';
import '../src/data_display/data_display_showcase.dart';
import '../src/effects/visual_effects_showcase.dart';
import '../src/form_controls/form_controls_showcase.dart';
import '../src/interactive/interactive_widgets_showcase.dart';
import '../src/layout/layout_widgets_showcase.dart';
import '../src/loading/loading_widgets_showcase.dart';

class WidgetDetailScreen extends StatelessWidget {
  final WidgetCategory category;

  const WidgetDetailScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: category.color,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              category.color.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: category.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        category.icon,
                        color: category.color,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      category.name,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: category.color,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimationLimiter(
                  child: _buildWidgetShowcase(category.type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetShowcase(String type) {
    switch (type) {
      case 'animations':
        return const AnimatedWidgetsShowcase();
      case 'custom_paint':
        return const CustomPaintShowcase();
      case 'interactive':
        return const InteractiveWidgetsShowcase();
      case 'layout':
        return const LayoutWidgetsShowcase();
      case 'effects':
        return const VisualEffectsShowcase();
      case 'form_controls':
        return const FormControlsShowcase();
      case 'loading':
        return const LoadingWidgetsShowcase();
      case 'data_display':
        return const DataDisplayShowcase();
      default:
        return const Center(
          child: Text('Coming Soon!'),
        );
    }
  }
}
