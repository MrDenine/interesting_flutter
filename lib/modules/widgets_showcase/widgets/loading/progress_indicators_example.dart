import 'package:flutter/material.dart';

class ProgressIndicatorsExample extends StatefulWidget {
  const ProgressIndicatorsExample({super.key});

  @override
  State<ProgressIndicatorsExample> createState() =>
      _ProgressIndicatorsExampleState();
}

class _ProgressIndicatorsExampleState extends State<ProgressIndicatorsExample>
    with TickerProviderStateMixin {
  late AnimationController _linearController;
  late AnimationController _circularController;
  late Animation<double> _linearAnimation;
  late Animation<double> _circularAnimation;

  @override
  void initState() {
    super.initState();

    _linearController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _circularController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _linearAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _linearController,
      curve: Curves.easeInOut,
    ));

    _circularAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _circularController,
      curve: Curves.easeInOut,
    ));

    _linearController.repeat(reverse: true);
    _circularController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _linearController.dispose();
    _circularController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Linear Progress Indicators
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Linear Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _linearAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: _linearAnimation.value,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _linearAnimation.value,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: _linearAnimation.value,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Circular Progress Indicators
        Column(
          children: [
            const Text(
              'Circular Progress',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedBuilder(
                  animation: _circularAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: _circularAnimation.value,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.purple),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          '${(_circularAnimation.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _circularAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: _circularAnimation.value,
                            backgroundColor: Colors.grey.shade300,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.red),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          '${(_circularAnimation.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _circularAnimation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: _circularAnimation.value,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.teal),
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          '${(_circularAnimation.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
