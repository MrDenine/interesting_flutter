import 'package:flutter/material.dart';

class CustomChoiceChip extends StatelessWidget {
  const CustomChoiceChip({super.key, required this.label, this.onDeleted});

  final String label;
  final void Function()? onDeleted;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.all(0),
      padding: const EdgeInsets.only(left: 12, top: 0, right: 4, bottom: 0),
      label: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onDeleted: () => onDeleted?.call(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      deleteIcon: Container(
        height: 20,
        width: 20,
        padding: EdgeInsets.all(2),
        child: Icon(
          Icons.close,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
