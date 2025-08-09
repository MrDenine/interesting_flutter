import 'package:flutter/material.dart';

class DraggableCard extends StatefulWidget {
  const DraggableCard({super.key});

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  Offset position = const Offset(50, 50);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable<String>(
            data: 'draggable_card',
            feedback: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.purple],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.drag_indicator,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            childWhenDragging: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onDragEnd: (details) {
              setState(() {
                // Calculate the new position relative to the Stack
                final RenderBox stackBox =
                    context.findRenderObject() as RenderBox;
                final Offset stackPosition =
                    stackBox.localToGlobal(Offset.zero);
                position = details.offset - stackPosition;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.drag_indicator,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
