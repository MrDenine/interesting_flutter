import 'package:flutter/material.dart';

class WidgetCategory {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String type;

  const WidgetCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
  });

  static List<WidgetCategory> getCategories() {
    return [
      const WidgetCategory(
        name: 'Animated Widgets',
        description: 'Beautiful animations and transitions',
        icon: Icons.animation,
        color: Color(0xFF6750A4),
        type: 'animations',
      ),
      const WidgetCategory(
        name: 'Custom Paint',
        description: 'Custom drawings and artistic widgets',
        icon: Icons.brush,
        color: Color(0xFFE91E63),
        type: 'custom_paint',
      ),
      const WidgetCategory(
        name: 'Interactive Widgets',
        description: 'Touch, gestures, and interactions',
        icon: Icons.touch_app,
        color: Color(0xFF2196F3),
        type: 'interactive',
      ),
      const WidgetCategory(
        name: 'Layout Widgets',
        description: 'Creative layouts and positioning',
        icon: Icons.view_quilt,
        color: Color(0xFF4CAF50),
        type: 'layout',
      ),
      const WidgetCategory(
        name: 'Loading & Progress',
        description: 'Spinners, progress bars, and loading states',
        icon: Icons.hourglass_empty,
        color: Color(0xFFFF9800),
        type: 'loading',
      ),
      const WidgetCategory(
        name: 'Visual Effects',
        description: 'Gradients, shadows, and visual magic',
        icon: Icons.auto_fix_high,
        color: Color(0xFF9C27B0),
        type: 'effects',
      ),
      const WidgetCategory(
        name: 'Data Display',
        description: 'Charts, graphs, and data visualization',
        icon: Icons.bar_chart,
        color: Color(0xFF607D8B),
        type: 'data_display',
      ),
      const WidgetCategory(
        name: 'Form Controls',
        description: 'Advanced form inputs and controls',
        icon: Icons.input,
        color: Color(0xFF795548),
        type: 'form_controls',
      ),
      const WidgetCategory(
        name: 'Maps_Location',
        description: 'Maps, markers, and geolocation',
        icon: Icons.map,
        color: Color(0xFF009688),
        type: 'maps_location',
      ),
      const WidgetCategory(
        name: 'Custom Showcase',
        description: 'Unique custom widgets and effects',
        icon: Icons.star,
        color: Color(0xFF3F51B5),
        type: 'custom_showcase',
      ),
      const WidgetCategory(
        name: 'Firebase Utils',
        description: 'Firebase connectivity and utilities',
        icon: Icons.cloud,
        color: Color(0xFFFF6F00),
        type: 'firebase_utils',
      ),
    ];
  }
}
