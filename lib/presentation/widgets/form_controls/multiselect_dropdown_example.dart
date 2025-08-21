import 'package:flutter/material.dart';
import 'multiselect_dropdown.dart';

class MultiselectDropdownExample extends StatefulWidget {
  const MultiselectDropdownExample({super.key});

  @override
  State<MultiselectDropdownExample> createState() =>
      _MultiselectDropdownExampleState();
}

class _MultiselectDropdownExampleState
    extends State<MultiselectDropdownExample> {
  final GlobalKey<State<MultiselectDropdown<String>>> _dropdownKey =
      GlobalKey();

  List<String> selectedItems = [];
  final List<String> items = [
    'Apple',
    'Banana',
    'Orange',
    'Grape',
    'Strawberry',
    'Pineapple',
    'Mango',
    'Watermelon',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiselect Dropdown Validation Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Example 1: Auto-validation with minimum selections',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MultiselectDropdown<String>(
              key: _dropdownKey,
              label: 'Select Fruits (Min 2, Max 5)',
              hint: 'Choose at least 2 fruits',
              items: items,
              selectedValues: selectedItems,
              displayStringForOption: (item) => item,
              onChanged: (values) {
                setState(() {
                  selectedItems = values;
                });
              },
              autoValidate: true,
              minSelections: 2,
              maxSelections: 5,
            ),
            const SizedBox(height: 32),
            const Text(
              'Example 2: Custom min selections message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MultiselectDropdown<String>(
              label: 'Select Fruits (Custom Min Message)',
              hint: 'Choose your favorite fruits',
              items: items,
              selectedValues: const [],
              displayStringForOption: (item) => item,
              onChanged: (values) {
                // Handle selection
              },
              autoValidate: true,
              minSelections: 3,
              minSelectionsErrorMessage:
                  'You must pick at least 3 of your favorite fruits to proceed!',
            ),
            const SizedBox(height: 32),
            const Text(
              'Example 3: Custom validation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            MultiselectDropdown<String>(
              label: 'Select Fruits (Custom Validation)',
              hint: 'Must include Apple or Banana',
              items: items,
              selectedValues: const [],
              displayStringForOption: (item) => item,
              onChanged: (values) {
                // Handle selection
              },
              autoValidate: true,
              validator: (selectedItems) {
                if (selectedItems.isEmpty) {
                  return 'Please select at least one fruit';
                }
                if (!selectedItems.contains('Apple') &&
                    !selectedItems.contains('Banana')) {
                  return 'Selection must include Apple or Banana';
                }
                return null; // No error
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Manual validation example
                final dropdownState = _dropdownKey.currentState as dynamic;
                final validationError = dropdownState?.validate();

                if (validationError == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Validation passed!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Validation failed: $validationError'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Validate Manually'),
            ),
          ],
        ),
      ),
    );
  }
}
