import 'package:flutter/material.dart';

class PulseLoading extends StatefulWidget {
  const PulseLoading({super.key});

  @override
  State<PulseLoading> createState() => _PulseLoadingState();
}

class _PulseLoadingState extends State<PulseLoading>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(3, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.3,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // Start animations with delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pulsing circles
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Transform.scale(
                    scale: _animations[index].value,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color:
                            Colors.blue.withOpacity(_animations[index].value),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue
                                .withOpacity(_animations[index].value * 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 30),
        // Pulsing text
        AnimatedBuilder(
          animation: _animations[1],
          builder: (context, child) {
            return Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.withOpacity(_animations[1].value),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        // Pulsing card
        AnimatedBuilder(
          animation: _animations[0],
          builder: (context, child) {
            return Transform.scale(
              scale: 0.9 + (_animations[0].value * 0.1),
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(_animations[0].value * 0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.withOpacity(_animations[0].value),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Please wait...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(_animations[0].value),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
