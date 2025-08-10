import 'package:flutter/material.dart';
import 'package:interesting_flutter/data/models/category_model.dart';

const List<CategoryModel> widgetCategories = [
  CategoryModel(
    name: 'Animated Widgets',
    description: 'Beautiful animations and transitions',
    icon: Icons.animation,
    color: Color(0xFF6750A4),
    type: 'animations',
  ),
  CategoryModel(
    name: 'Custom Paint',
    description: 'Custom drawings and artistic widgets',
    icon: Icons.brush,
    color: Color(0xFFE91E63),
    type: 'custom_paint',
  ),
  CategoryModel(
    name: 'Interactive Widgets',
    description: 'Touch, gestures, and interactions',
    icon: Icons.touch_app,
    color: Color(0xFF2196F3),
    type: 'interactive',
  ),
  CategoryModel(
    name: 'Layout Widgets',
    description: 'Creative layouts and positioning',
    icon: Icons.view_quilt,
    color: Color(0xFF4CAF50),
    type: 'layout',
  ),
  CategoryModel(
    name: 'Loading & Progress',
    description: 'Spinners, progress bars, and loading states',
    icon: Icons.hourglass_empty,
    color: Color(0xFFFF9800),
    type: 'loading',
  ),
  CategoryModel(
    name: 'Visual Effects',
    description: 'Gradients, shadows, and visual magic',
    icon: Icons.auto_fix_high,
    color: Color(0xFF9C27B0),
    type: 'effects',
  ),
  CategoryModel(
    name: 'Data Display',
    description: 'Charts, graphs, and data visualization',
    icon: Icons.bar_chart,
    color: Color(0xFF607D8B),
    type: 'data_display',
  ),
  CategoryModel(
    name: 'Form Controls',
    description: 'Advanced form inputs and controls',
    icon: Icons.input,
    color: Color(0xFF795548),
    type: 'form_controls',
  ),
  CategoryModel(
    name: 'Maps & Location',
    description: 'Maps, markers, and geolocation',
    icon: Icons.map,
    color: Color(0xFF009688),
    type: 'maps_location',
  ),
  CategoryModel(
    name: 'Modal & Alerts',
    description: 'Dialogs, modals, and alert components',
    icon: Icons.open_in_new,
    color: Color(0xFFFF5722),
    type: 'modal',
  ),
  CategoryModel(
    name: 'Custom Showcase',
    description: 'Unique custom widgets and effects',
    icon: Icons.star,
    color: Color(0xFF3F51B5),
    type: 'custom_showcase',
  ),
];
