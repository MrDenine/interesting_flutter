import 'package:flutter/material.dart';

class InteractiveButton extends StatefulWidget {
  const InteractiveButton({super.key});

  @override
  State<InteractiveButton> createState() => _InteractiveButtonState();
}

class _InteractiveButtonState extends State<InteractiveButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _scaleController.forward();
  }

  void _onTapUp() {
    _scaleController.reverse();
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    setState(() {
      _tapCount++;
    });
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_scaleAnimation, _rippleAnimation]),
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTapDown: (_) => _onTapDown(),
                  onTapUp: (_) => _onTapUp(),
                  onTapCancel: _onTapCancel,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orange, Colors.red],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: _rippleAnimation.value * 10,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ripple effect
                        Container(
                          width: 120 + (_rippleAnimation.value * 40),
                          height: 120 + (_rippleAnimation.value * 40),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.orange.withValues(
                                alpha: 1.0 - _rippleAnimation.value,
                              ),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              60 + (_rippleAnimation.value * 20),
                            ),
                          ),
                        ),
                        // Button content
                        const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Tapped $_tapCount times',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
