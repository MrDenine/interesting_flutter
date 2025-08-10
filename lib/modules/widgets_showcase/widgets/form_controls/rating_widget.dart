import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget({super.key});

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget>
    with TickerProviderStateMixin {
  int _rating = 0;
  int _hoverRating = 0;
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(5, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      );
    });

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onStarTap(int index) {
    setState(() {
      _rating = index + 1;
    });
    _controllers[index].forward().then((_) {
      _controllers[index].reverse();
    });
  }

  void _onStarHover(int index) {
    setState(() {
      _hoverRating = index + 1;
    });
  }

  void _onStarExit() {
    setState(() {
      _hoverRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Rate your experience',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final isSelected =
                index < (_hoverRating > 0 ? _hoverRating : _rating);
            return MouseRegion(
              onEnter: (_) => _onStarHover(index),
              onExit: (_) => _onStarExit(),
              child: GestureDetector(
                onTap: () => _onStarTap(index),
                child: AnimatedBuilder(
                  animation: _scaleAnimations[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          isSelected ? Icons.star : Icons.star_border,
                          color: isSelected ? Colors.amber : Colors.grey,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        if (_rating > 0)
          Text(
            'You rated: $_rating star${_rating > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
