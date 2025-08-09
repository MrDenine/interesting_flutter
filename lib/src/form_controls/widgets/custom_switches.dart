import 'package:flutter/material.dart';

class CustomSwitches extends StatefulWidget {
  const CustomSwitches({super.key});

  @override
  State<CustomSwitches> createState() => _CustomSwitchesState();
}

class _CustomSwitchesState extends State<CustomSwitches> {
  bool _switch1 = false;
  bool _switch2 = true;
  bool _switch3 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSwitchRow('Notifications', _switch1, (value) {
          setState(() => _switch1 = value);
        }, Colors.blue),
        const SizedBox(height: 16),
        _buildSwitchRow('Dark Mode', _switch2, (value) {
          setState(() => _switch2 = value);
        }, Colors.purple),
        const SizedBox(height: 16),
        _buildSwitchRow('Auto Sync', _switch3, (value) {
          setState(() => _switch3 = value);
        }, Colors.green),
      ],
    );
  }

  Widget _buildSwitchRow(
      String label, bool value, Function(bool) onChanged, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: value ? color : Colors.grey.withValues(alpha: 0.3),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: value ? 25 : 0,
                child: GestureDetector(
                  onTap: () => onChanged(!value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      value ? Icons.check : Icons.close,
                      size: 16,
                      color: value ? color : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
