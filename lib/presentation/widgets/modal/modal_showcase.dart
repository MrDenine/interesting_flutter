import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'alert_dialog.dart';
import 'confirmation_dialog.dart';
import 'custom_modal.dart';
import 'bottom_sheet.dart';
import 'loading_dialog.dart';
import 'input_dialog.dart';

class ModalShowcase extends StatelessWidget {
  const ModalShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              AlertDialogDemo(),
              ConfirmationDialog(),
              CustomModal(),
              CustomBottomSheet(),
              LoadingDialog(),
              InputDialog(),
            ],
          ),
        ),
      ),
    );
  }
}
