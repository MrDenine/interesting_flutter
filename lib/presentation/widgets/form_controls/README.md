# MultiselectDropdownFormField Documentation

## Overview

The `MultiselectDropdownFormField` is a Flutter widget that extends `FormField` to provide seamless integration with Flutter forms. It wraps the `MultiselectDropdown` widget to handle form validation, state management, and provides proper integration with `Form` widgets for saving and resetting values.

## Key Features

- **Full Form Integration**: Works seamlessly with Flutter's `Form` widget
- **Automatic Validation**: Supports both custom validators and built-in validation rules
- **State Management**: Properly handles form field state including save, reset, and validation
- **Error Display**: Shows validation errors below the dropdown
- **Auto-validation**: Supports different auto-validation modes
- **Generic Type Support**: Works with any data type

## Basic Usage

```dart
MultiselectDropdownFormField<String>(
  label: 'Select Fruits',
  items: ['Apple', 'Banana', 'Orange'],
  displayStringForOption: (item) => item,
  validator: (values) {
    if (values == null || values.isEmpty) {
      return 'Please select at least one fruit';
    }
    return null;
  },
  onSaved: (values) => selectedFruits = values ?? [],
)
```

## Form Integration Example

```dart
class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> selectedFruits = [];

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Use selectedFruits here
      print('Selected fruits: $selectedFruits');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MultiselectDropdownFormField<String>(
            label: 'Favorite Fruits',
            items: ['Apple', 'Banana', 'Orange', 'Grape'],
            displayStringForOption: (item) => item,
            initialValue: ['Apple'], // Pre-select Apple
            minSelections: 1,
            maxSelections: 3,
            validator: (values) {
              if (values == null || values.isEmpty) {
                return 'Please select at least one fruit';
              }
              return null;
            },
            onSaved: (values) => selectedFruits = values ?? [],
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## Parameters

### Required Parameters

- `items`: List of items to display in the dropdown
- `displayStringForOption`: Function to convert each item to its string representation

### Common Parameters

- `label`: Label text displayed above the dropdown
- `hint`: Hint text when no items are selected
- `initialValue`: Initial selected values
- `validator`: Custom validation function
- `onSaved`: Callback when form is saved
- `autovalidateMode`: When to automatically validate
- `minSelections`: Minimum number of required selections
- `maxSelections`: Maximum number of allowed selections

### UI Customization

- `itemBuilder`: Custom widget builder for dropdown items
- `searchHint`: Hint text for the search field
- `maxHeight`: Maximum height of the dropdown overlay
- `innerPadding`: Custom padding for the dropdown content
- `showSelectAll`: Whether to show Select All button
- `showNumberOfSelected`: Whether to show selection count badge
- `showClearSelectedItemButton`: Whether to show Clear button

## Validation

### Built-in Validation

The form field supports built-in validation for minimum selections:

```dart
MultiselectDropdownFormField<String>(
  // ... other parameters
  minSelections: 2,
  minSelectionsErrorMessage: 'Please select at least 2 items',
)
```

### Custom Validation

You can provide custom validation logic:

```dart
MultiselectDropdownFormField<String>(
  // ... other parameters
  validator: (values) {
    if (values == null || values.isEmpty) {
      return 'Selection is required';
    }
    if (values.length > 5) {
      return 'Maximum 5 selections allowed';
    }
    if (values.contains('InvalidOption')) {
      return 'Invalid option selected';
    }
    return null; // Valid
  },
)
```

### Auto-validation Modes

```dart
MultiselectDropdownFormField<String>(
  // ... other parameters
  autovalidateMode: AutovalidateMode.onUserInteraction, // Validate on user interaction
  // autovalidateMode: AutovalidateMode.always, // Always validate
  // autovalidateMode: AutovalidateMode.disabled, // Manual validation only
)
```

## Working with Complex Objects

```dart
class Person {
  final String id;
  final String name;
  final String email;

  Person(this.id, this.name, this.email);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

MultiselectDropdownFormField<Person>(
  label: 'Select Team Members',
  items: people,
  displayStringForOption: (person) => person.name,
  itemBuilder: (person) => ListTile(
    title: Text(person.name),
    subtitle: Text(person.email),
  ),
  validator: (values) {
    if (values == null || values.length < 2) {
      return 'Please select at least 2 team members';
    }
    return null;
  },
  onSaved: (values) => selectedTeamMembers = values ?? [],
)
```

## Key Differences from MultiselectDropdown

| Feature          | MultiselectDropdown   | MultiselectDropdownFormField |
| ---------------- | --------------------- | ---------------------------- |
| Form Integration | No                    | Yes                          |
| Validation       | Manual only           | Automatic + Manual           |
| State Management | Manual                | Automatic                    |
| Error Display    | Custom implementation | Built-in                     |
| Save/Reset       | Manual                | Automatic with Form          |

## Best Practices

1. **Always use within a Form widget** for proper integration
2. **Implement proper equality operators** for custom objects
3. **Use auto-validation** for better UX with `AutovalidateMode.onUserInteraction`
4. **Combine built-in and custom validation** for comprehensive validation logic
5. **Handle null values** in validators and onSaved callbacks
6. **Use meaningful error messages** that guide users to correct their input

## Migration from MultiselectDropdown

To migrate from `MultiselectDropdown` to `MultiselectDropdownFormField`:

1. Wrap your existing dropdown in a `Form` widget
2. Replace `MultiselectDropdown` with `MultiselectDropdownFormField`
3. Remove manual state management for selected values
4. Add `validator` and `onSaved` callbacks
5. Use `initialValue` instead of `selectedValues`
6. Remove manual validation logic

Before:

```dart
MultiselectDropdown<String>(
  selectedValues: selectedItems,
  onChanged: (values) => setState(() => selectedItems = values),
  // manual validation logic
)
```

After:

```dart
MultiselectDropdownFormField<String>(
  initialValue: selectedItems,
  validator: (values) => /* validation logic */,
  onSaved: (values) => selectedItems = values ?? [],
)
```
