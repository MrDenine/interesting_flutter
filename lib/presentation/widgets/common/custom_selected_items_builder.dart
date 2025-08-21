import 'package:flutter/material.dart';
import 'package:interesting_flutter/presentation/widgets/common/custom_choice_chip.dart';

class CustomSelectedItemsBuilder<T> extends StatelessWidget {
  const CustomSelectedItemsBuilder(
      {super.key,
      required List<T> selectedItems,
      this.hint,
      required this.displayStringForOption,
      this.onDeleted})
      : _selectedItems = selectedItems;

  final List<T> _selectedItems;
  final String? hint;
  final String Function(T) displayStringForOption;
  final ValueChanged<T>? onDeleted;

  @override
  Widget build(BuildContext context) {
    if (_selectedItems.isEmpty) {
      return Text(
        hint ?? 'Select options',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: _selectedItems
          .map((item) => CustomChoiceChip(
                label: displayStringForOption(item),
                onDeleted: () => onDeleted?.call(item),
              ))
          .toList(),
    );
  }
}
