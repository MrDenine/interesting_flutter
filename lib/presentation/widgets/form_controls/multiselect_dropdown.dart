import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiselectDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final List<T> items;
  final List<T> selectedValues;
  final String Function(T) displayStringForOption;
  final Widget Function(T)? itemBuilder;
  final ValueChanged<List<T>>? onChanged;
  final String? searchHint;
  final double maxHeight;
  final bool enabled;
  final int? maxSelections;
  final Widget Function(List<T>)? selectedItemsBuilder;
  final bool showSelectAll;

  const MultiselectDropdown({
    super.key,
    required this.label,
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
    }
  }

  @override
  void dispose() {
    // _animationController.dispose();
    // _searchController.dispose();
    // _searchFocusNode.dispose();
    // _dropdownFocusNode.dispose();
    // _closeDropdown();
    super.dispose();
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
    _searchFocusNode.requestFocus();
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
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
    widget.onChanged?.call(_selectedItems);
    _overlayEntry?.markNeedsBuild();
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
                                          if (_selectedItems.isNotEmpty)
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
    if (widget.selectedItemsBuilder != null) {
      return widget.selectedItemsBuilder!(_selectedItems);
    }

    if (_selectedItems.isEmpty) {
      return Text(
        widget.hint ?? 'Select options',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      );
    }

    if (_selectedItems.length == 1) {
      return Text(
        widget.displayStringForOption(_selectedItems.first),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      );
    }

    if (_selectedItems.length <= 3) {
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: _selectedItems
            .map((item) => Chip(
                  label: Text(
                    widget.displayStringForOption(item),
                    style: const TextStyle(fontSize: 12),
                  ),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => _toggleItemSelection(item),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ))
            .toList(),
      );
    }

    return Row(
      children: [
        Chip(
          label: Text(
            widget.displayStringForOption(_selectedItems.first),
            style: const TextStyle(fontSize: 12),
          ),
          deleteIcon: const Icon(Icons.close, size: 14),
          onDeleted: () => _toggleItemSelection(_selectedItems.first),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '+${_selectedItems.length - 1} more',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _dropdownFocusNode,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: _isOpen
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: _isOpen ? 2 : 1,
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
                    Expanded(
                      child: Text(
                        widget.label,
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: _isOpen
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                      ),
                    ),
                    if (_selectedItems.isNotEmpty)
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildSelectedItemsDisplay(),
                    ),
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
      ),
    );
  }
}
