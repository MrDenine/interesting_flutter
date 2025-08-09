import 'package:flutter/material.dart';

class StatisticsCards extends StatefulWidget {
  const StatisticsCards({super.key});

  @override
  State<StatisticsCards> createState() => _StatisticsCardsState();
}

class _StatisticsCardsState extends State<StatisticsCards>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  late AnimationController _countController;
  late List<Animation<int>> _countAnimations;

  final List<StatData> _stats = [
    StatData(
      title: 'Total Users',
      value: 12450,
      icon: Icons.people,
      color: Colors.blue,
      change: 12.5,
      isPositive: true,
    ),
    StatData(
      title: 'Revenue',
      value: 98750,
      icon: Icons.attach_money,
      color: Colors.green,
      change: 8.2,
      isPositive: true,
      prefix: '\$',
    ),
    StatData(
      title: 'Orders',
      value: 3842,
      icon: Icons.shopping_cart,
      color: Colors.orange,
      change: -2.1,
      isPositive: false,
    ),
    StatData(
      title: 'Sessions',
      value: 28690,
      icon: Icons.visibility,
      color: Colors.purple,
      change: 15.3,
      isPositive: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _countController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animations = List.generate(_stats.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          0.8 + index * 0.05,
          curve: Curves.elasticOut,
        ),
      ));
    });

    _countAnimations = _stats.map((stat) {
      return IntTween(
        begin: 0,
        end: stat.value,
      ).animate(CurvedAnimation(
        parent: _countController,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    _controller.forward();
    _countController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling since it's in a container
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation:
              Listenable.merge([_animations[index], _countAnimations[index]]),
          builder: (context, child) {
            final scale = _animations[index].value;
            final count = _countAnimations[index].value;

            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _stats[index].color.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background gradient
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _stats[index].color.withValues(alpha: 0.05),
                            _stats[index].color.withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: _stats[index]
                                      .color
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _stats[index].icon,
                                  color: _stats[index].color,
                                  size: 24,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: _stats[index].isPositive
                                      ? Colors.green.withValues(alpha: 0.1)
                                      : Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _stats[index].isPositive
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      size: 12,
                                      color: _stats[index].isPositive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${_stats[index].change.abs().toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: _stats[index].isPositive
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _stats[index].title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${_stats[index].prefix}${_formatNumber(count)}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _stats[index].color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Floating decoration
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _stats[index].color.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class StatData {
  final String title;
  final int value;
  final IconData icon;
  final Color color;
  final double change;
  final bool isPositive;
  final String prefix;

  StatData({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
    required this.isPositive,
    this.prefix = '',
  });
}
