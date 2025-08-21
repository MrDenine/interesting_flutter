import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable multi-select dropdown widget that allows users to select multiple items
/// from a list with search functionality, validation, and various customization options.
class MultiselectDropdown<T> extends StatefulWidget {
  /// The label text displayed above the dropdown field.
  /// If null, no label will be shown.
  final String? label;

  /// The hint text displayed when no items are selected.
  /// Defaults to 'Select options' if null.
  final String? hint;

  /// The list of items to display in the dropdown.
  /// This is required and cannot be empty for the dropdown to function properly.
  final List<T> items;

  /// The list of currently selected items.
  /// This allows for pre-selecting items when the widget is first displayed.
  /// Defaults to an empty list.
  final List<T> selectedValues;

  /// A function that converts each item to its string representation for display.
  /// This is required and determines how items appear in the dropdown and as selected chips.
  final String Function(T) displayStringForOption;

  /// An optional custom widget builder for each dropdown item.
  /// If provided, this will be used instead of the default text display.
  /// Useful for showing complex item layouts with icons, subtitles, etc.
  final Widget Function(T)? itemBuilder;

  /// Callback function called when the selection changes.
  /// Receives the updated list of selected items.
  final ValueChanged<List<T>>? onChanged;

  /// The hint text displayed in the search field.
  /// Defaults to 'Search...' if null.
  final String? searchHint;

  /// The maximum height of the dropdown overlay in pixels.
  /// The dropdown will automatically adjust to screen constraints.
  /// Defaults to 300 pixels.
  final double maxHeight;

  /// Whether the dropdown is enabled for user interaction.
  /// When false, the dropdown appears disabled and cannot be opened.
  /// Defaults to true.
  final bool enabled;

  /// The maximum number of items that can be selected.
  /// If null, there is no limit on selections.
  /// When the limit is reached, unselected items become disabled.
  final int? maxSelections;

  /// Custom widget builder for displaying selected items.
  /// Currently not implemented but reserved for future use.
  final Widget Function(List<T>)? selectedItemsBuilder;

  /// Whether to show the "Select All" / "Deselect All" button in the dropdown.
  /// Defaults to true.
  final bool showSelectAll;

  /// Whether to show a badge with the number of selected items.
  /// The badge appears in the top-right corner of the dropdown field.
  /// Defaults to true.
  final bool showNumberOfSelected;

  /// Whether to automatically focus the search field when the dropdown opens.
  /// Defaults to true for better keyboard navigation.
  final bool focusSearchOnOpen;

  /// Custom padding for the inner content of the dropdown field.
  /// If null, uses default padding of EdgeInsets.symmetric(horizontal: 12, vertical: 16).
  final EdgeInsetsGeometry? innerPadding;

  /// Whether to show the "Clear" button that removes all selected items.
  /// Defaults to true. The button only appears when items are selected.
  final bool? showClearSelectedItemButton;

  /// Custom validation function that receives the list of selected items
  /// and returns an error message string if validation fails, or null if valid.
  /// This takes priority over built-in validation (minSelections).
  final String? Function(List<T>)? validator;

  /// Whether to automatically validate the selection when items are added/removed.
  /// When true, validation occurs immediately on selection changes.
  /// When false, validation only occurs when validate() is called manually.
  /// Defaults to false.
  final bool autoValidate;

  /// The minimum number of items that must be selected for the selection to be valid.
  /// If specified, built-in validation will ensure at least this many items are selected.
  /// Works in conjunction with minSelectionsErrorMessage for custom error text.
  final int? minSelections;

  /// Custom error message to display when minSelections validation fails.
  /// If null, a default message like "Please select at least X items" will be used.
  /// Only used when minSelections is specified and no custom validator is provided.
  final String? minSelectionsErrorMessage;

  /// Creates a MultiselectDropdown widget.
  ///
  /// The [items] and [displayStringForOption] parameters are required.
  /// All other parameters are optional and have sensible defaults.
  ///
  /// Example usage:
  /// ```dart
  /// MultiselectDropdown<String>(
  ///   label: 'Select Fruits',
  ///   items: ['Apple', 'Banana', 'Orange'],
  ///   displayStringForOption: (item) => item,
  ///   selectedValues: selectedFruits,
  ///   onChanged: (values) => setState(() => selectedFruits = values),
  ///   autoValidate: true,
  ///   minSelections: 1,
  ///   maxSelections: 3,
  /// )
  /// ```
  const MultiselectDropdown({
    super.key,
    this.label,
    required this.items,
    required this.displayStringForOption,
    this.hint,
    this.selectedValues = const [],
    this.itemBuilder,
    this.onChanged,
    this.searchHint = 'Search...',
    this.maxHeight = 300,
    this.enabled = true,
    this.maxSelections,
    this.selectedItemsBuilder,
    this.showSelectAll = true,
    this.showNumberOfSelected = true,
    this.focusSearchOnOpen = true,
    this.innerPadding,
    this.showClearSelectedItemButton = true,
    this.validator,
    this.autoValidate = false,
    this.minSelections,
    this.minSelectionsErrorMessage,
  });

  @override
  State<MultiselectDropdown<T>> createState() => _MultiselectDropdownState<T>();
}

class _MultiselectDropdownState<T> extends State<MultiselectDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _dropdownFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  List<T> _selectedItems = [];
  bool _isOpen = false;
  int _highlightedIndex = -1;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _selectedItems = List.from(widget.selectedValues);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _searchController.addListener(_onSearchChanged);

    // Add focus listener to close dropdown when focus is lost
    _dropdownFocusNode.addListener(_onFocusChanged);

    // Initial validation if auto-validation is enabled
    if (widget.autoValidate) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _validate());
    }
  }

  void _onFocusChanged() {
    if (!_dropdownFocusNode.hasFocus && !_searchFocusNode.hasFocus && _isOpen) {
      // Close dropdown when both focus nodes lose focus
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_dropdownFocusNode.hasFocus &&
            !_searchFocusNode.hasFocus &&
            _isOpen) {
          _closeDropdown();
        }
      });
    }
  }

  @override
  void didUpdateWidget(MultiselectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValues != oldWidget.selectedValues) {
      _selectedItems = List.from(widget.selectedValues);

      // Validate if auto-validation is enabled
      if (widget.autoValidate) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _validate());
      }
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.items.where((item) {
        final displayString = widget.displayStringForOption(item).toLowerCase();
        return displayString.contains(query);
      }).toList();
      _highlightedIndex = _filteredItems.isNotEmpty ? 0 : -1;
    });
    _overlayEntry?.markNeedsBuild();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    //Todo: focus
    if (widget.focusSearchOnOpen) {
      _searchFocusNode.requestFocus();
    }
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
    _searchController.clear();
    _filteredItems = widget.items;
    _highlightedIndex = -1;
    setState(() => _isOpen = false);
  }

  void _toggleItemSelection(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        if (widget.maxSelections == null ||
            _selectedItems.length < widget.maxSelections!) {
          _selectedItems.add(item);
        }
      }
    });
    widget.onChanged?.call(_selectedItems);
    _overlayEntry?.markNeedsBuild();

    // Validate if auto-validation is enabled
    if (widget.autoValidate) {
      _validate();
    }
  }

  void _selectAll() {
    setState(() {
      if (_filteredItems.every((item) => _selectedItems.contains(item))) {
        // Deselect all filtered items
        _selectedItems.removeWhere((item) => _filteredItems.contains(item));
      } else {
        // Select all filtered items
        for (final item in _filteredItems) {
          if (!_selectedItems.contains(item)) {
            if (widget.maxSelections == null ||
                _selectedItems.length < widget.maxSelections!) {
              _selectedItems.add(item);
            }
          }
        }
      }
    });
    widget.onChanged?.call(_selectedItems);
    _overlayEntry?.markNeedsBuild();

    // Validate if auto-validation is enabled
    if (widget.autoValidate) {
      _validate();
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
    widget.onChanged?.call(_selectedItems);
    _overlayEntry?.markNeedsBuild();

    // Validate if auto-validation is enabled
    if (widget.autoValidate) {
      _validate();
    }
  }

  String? _validate() {
    if (widget.validator != null) {
      final error = widget.validator!(_selectedItems);
      setState(() {
        _errorMessage = error;
      });
      return error;
    }

    // Built-in validation for minimum selections
    if (widget.minSelections != null &&
        _selectedItems.length < widget.minSelections!) {
      final error = widget.minSelectionsErrorMessage ??
          'Please select at least ${widget.minSelections} item${widget.minSelections! > 1 ? 's' : ''}';
      setState(() {
        _errorMessage = error;
      });
      return error;
    }

    setState(() {
      _errorMessage = null;
    });
    return null;
  }

  /// Manually triggers validation of the current selection.
  ///
  /// Returns the validation error message if validation fails,
  /// or null if the current selection is valid.
  ///
  /// This method can be called from outside the widget to validate
  /// the selection state, useful for form validation scenarios.
  ///
  /// Example:
  /// ```dart
  /// final dropdownKey = GlobalKey<State<MultiselectDropdown<String>>>();
  ///
  /// // Later in your code:
  /// final error = (dropdownKey.currentState as dynamic)?.validate();
  /// if (error != null) {
  ///   // Handle validation error
  ///   print('Validation failed: $error');
  /// }
  /// ```
  String? validate() {
    return _validate();
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _highlightedIndex = (_highlightedIndex + 1) % _filteredItems.length;
        });
        _overlayEntry?.markNeedsBuild();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _highlightedIndex = _highlightedIndex > 0
              ? _highlightedIndex - 1
              : _filteredItems.length - 1;
        });
        _overlayEntry?.markNeedsBuild();
      } else if (event.logicalKey == LogicalKeyboardKey.enter &&
          _highlightedIndex >= 0) {
        _toggleItemSelection(_filteredItems[_highlightedIndex]);
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _closeDropdown();
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate position relative to screen
    final position = renderBox.localToGlobal(Offset.zero);
    final spaceBelow = screenHeight - position.dy - size.height;
    final spaceAbove = position.dy;

    // Dynamic height calculation - use up to 60% of screen height or available space
    final maxAvailableHeight =
        spaceBelow > spaceAbove ? spaceBelow - 20 : spaceAbove - 20;
    final dynamicMaxHeight =
        (screenHeight * 0.6).clamp(200.0, maxAvailableHeight);
    final finalMaxHeight = widget.maxHeight > 0
        ? widget.maxHeight.clamp(200.0, dynamicMaxHeight)
        : dynamicMaxHeight;

    final allSelected = _filteredItems.isNotEmpty &&
        _filteredItems.every((item) => _selectedItems.contains(item));

    // Determine if dropdown should appear above or below
    final shouldShowAbove = spaceBelow < 300 && spaceAbove > spaceBelow;
    final offsetY = shouldShowAbove ? -(finalMaxHeight + 5) : size.height + 5;

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Close dropdown when tapping outside
          _closeDropdown();
        },
        child: Stack(
          children: [
            // Invisible background to catch taps
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Dropdown content
            Positioned(
              width: size.width.clamp(200.0, screenWidth * 0.9),
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, offsetY),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Prevent closing when tapping inside the dropdown
                  },
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.8 + (0.2 * _animation.value),
                          alignment: shouldShowAbove
                              ? Alignment.bottomCenter
                              : Alignment.topCenter,
                          child: Opacity(
                            opacity: _animation.value,
                            child: Container(
                              constraints: BoxConstraints(
                                maxHeight: finalMaxHeight,
                                minHeight: 150,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Search field
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Focus(
                                      onKeyEvent: (node, event) {
                                        _handleKeyPress(event);
                                        return KeyEventResult.handled;
                                      },
                                      child: TextField(
                                        controller: _searchController,
                                        focusNode: _searchFocusNode,
                                        decoration: InputDecoration(
                                          hintText: widget.searchHint,
                                          prefixIcon: const Icon(Icons.search),
                                          suffixIcon: _searchController
                                                  .text.isNotEmpty
                                              ? IconButton(
                                                  icon: const Icon(Icons.clear),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                    _searchFocusNode
                                                        .requestFocus();
                                                  },
                                                )
                                              : null,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Action buttons
                                  if (widget.showSelectAll ||
                                      _selectedItems.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      child: Row(
                                        children: [
                                          if (widget.showSelectAll &&
                                              _filteredItems.isNotEmpty)
                                            TextButton.icon(
                                              onPressed: _selectAll,
                                              icon: Icon(
                                                allSelected
                                                    ? Icons.deselect
                                                    : Icons.select_all,
                                                size: 16,
                                              ),
                                              label: Text(
                                                allSelected
                                                    ? 'Deselect All'
                                                    : 'Select All',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              style: TextButton.styleFrom(
                                                minimumSize: Size.zero,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                              ),
                                            ),
                                          const Spacer(),
                                          if (_selectedItems.isNotEmpty &&
                                              (widget.showClearSelectedItemButton ??
                                                  true))
                                            TextButton.icon(
                                              onPressed: _clearSelection,
                                              icon: const Icon(Icons.clear_all,
                                                  size: 16),
                                              label: const Text(
                                                'Clear',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              style: TextButton.styleFrom(
                                                minimumSize: Size.zero,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                  const Divider(height: 1),

                                  // Items list
                                  if (_filteredItems.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'No results found',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    )
                                  else
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        itemCount: _filteredItems.length,
                                        itemBuilder: (context, index) {
                                          final item = _filteredItems[index];
                                          final isHighlighted =
                                              index == _highlightedIndex;
                                          final isSelected =
                                              _selectedItems.contains(item);
                                          final isDisabled = !isSelected &&
                                              widget.maxSelections != null &&
                                              _selectedItems.length >=
                                                  widget.maxSelections!;

                                          return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: isDisabled
                                                  ? null
                                                  : () => _toggleItemSelection(
                                                      item),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isHighlighted
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer
                                                          .withValues(
                                                              alpha: 0.3)
                                                      : isSelected
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .primaryContainer
                                                              .withValues(
                                                                  alpha: 0.1)
                                                          : null,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Checkbox(
                                                      value: isSelected,
                                                      onChanged: isDisabled
                                                          ? null
                                                          : (value) =>
                                                              _toggleItemSelection(
                                                                  item),
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Opacity(
                                                        opacity: isDisabled
                                                            ? 0.5
                                                            : 1.0,
                                                        child: widget
                                                                .itemBuilder
                                                                ?.call(item) ??
                                                            Text(
                                                              widget
                                                                  .displayStringForOption(
                                                                      item),
                                                              style: TextStyle(
                                                                fontWeight: isSelected
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .normal,
                                                                color: isSelected
                                                                    ? Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary
                                                                    : null,
                                                              ),
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedItemsDisplay() {
    // if (widget.selectedItemsBuilder != null) {
    //   return widget.selectedItemsBuilder!(_selectedItems);
    // }

    if (_selectedItems.isEmpty) {
      return Text(
        widget.hint ?? 'Select options',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: _selectedItems
          .map((item) => Chip(
                labelPadding: const EdgeInsets.all(0),
                padding: const EdgeInsets.only(
                    left: 12, top: 0, right: 4, bottom: 0),
                label: Text(
                  widget.displayStringForOption(item),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                onDeleted: () => _toggleItemSelection(item),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
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
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _dropdownFocusNode,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _toggleDropdown,
              child: Container(
                padding: widget.innerPadding ??
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _errorMessage != null
                        ? Theme.of(context).colorScheme.error
                        : _isOpen
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                    width: _isOpen || _errorMessage != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: widget.enabled
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        if (widget.label != null) ...[
                          Expanded(
                            child: Text(
                              widget.label ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                    color: _errorMessage != null
                                        ? Theme.of(context).colorScheme.error
                                        : _isOpen
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                        if (_selectedItems.isNotEmpty &&
                            widget.showNumberOfSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${_selectedItems.length}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSelectedItemsDisplay(),
                        ),
                        // Arrow icon
                        AnimatedRotation(
                          turns: _isOpen ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: widget.enabled
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.38),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Error message
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 4),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
