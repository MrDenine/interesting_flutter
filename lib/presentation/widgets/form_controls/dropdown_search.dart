import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final String label;
  final String? hint;
  final List<T> items;
  final T? value;
  final String Function(T) displayStringForOption;
  final Widget Function(T)? itemBuilder;
  final ValueChanged<T?>? onChanged;
  final String? searchHint;
  final double maxHeight;
  final bool enabled;

  const SearchableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.displayStringForOption,
    this.hint,
    this.value,
    this.itemBuilder,
    this.onChanged,
    this.searchHint = 'Search...',
    this.maxHeight = 300,
    this.enabled = true,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _dropdownFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  bool _isOpen = false;
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;

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
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _dropdownFocusNode.dispose();
    _closeDropdown();
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

  void _selectItem(T item) {
    widget.onChanged?.call(item);
    _closeDropdown();
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
        _selectItem(_filteredItems[_highlightedIndex]);
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
                                              widget.value == item;

                                          return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () => _selectItem(item),
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
                                                    Expanded(
                                                      child: widget.itemBuilder
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
                                                    if (isSelected)
                                                      Icon(
                                                        Icons.check,
                                                        size: 20,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
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
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _isOpen
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.value != null
                            ? widget.displayStringForOption(widget.value as T)
                            : widget.hint ?? 'Select an option',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.value != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                      ),
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
