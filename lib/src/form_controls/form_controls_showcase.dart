import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:interesting_flutter/src/form_controls/widgets/image_upload_field.dart';

import '../common/showcase_card.dart';
import 'widgets/animated_text_fields.dart';
import 'widgets/custom_switches.dart';
import 'widgets/date_picker_fields.dart';
import 'widgets/dropdown_search_demo.dart';
import 'widgets/multiselect_dropdown_demo.dart';
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
        children: [
          const AnimatedShowcaseCard(
            title: 'Animated Text Fields',
            description: 'Text fields with smooth animations',
            child: AnimatedTextFields(),
          ),
          const SizedBox(height: 16),
          const AnimatedShowcaseCard(
            title: 'Custom Switches',
            description: 'Beautiful animated toggle switches',
            child: CustomSwitches(),
          ),
          const SizedBox(height: 16),
          const AnimatedShowcaseCard(
            title: 'Range Slider',
            description: 'Dual-handle range slider',
            child: RangeSliderExample(),
          ),
          const SizedBox(height: 16),
          const AnimatedShowcaseCard(
            title: 'Rating Widget',
            description: 'Interactive star rating component',
            child: RatingWidget(),
          ),
          const SizedBox(height: 16),
          const AnimatedShowcaseCard(
            title: 'Date Pickers',
            description: 'Various date, time, and range pickers',
            child: DatePickerFields(),
          ),
          const SizedBox(height: 16),
          const AnimatedShowcaseCard(
            title: 'Dropdown Search',
            description: 'Searchable dropdown with filtering capabilities',
            child: DropdownSearchDemo(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Multiselect Dropdown',
            description: 'Select multiple options with search and chips',
            child: MultiselectDropdownDemo(),
          ),
          const SizedBox(height: 16),
          AnimatedShowcaseCard(
            title: 'Image Upload',
            description: 'Image upload field with animations',
            child: ImageUploadField(
              label: 'Upload Image',
              hint: 'Tap to select an image',
              onImageSelected: (File? image) {
                // Handle image selection
              },
            ),
          ),
        ],
      ),
    );
  }
}
