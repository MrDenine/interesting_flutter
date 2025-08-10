import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String type;

  const CategoryModel({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.type,
  });
}
