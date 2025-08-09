import 'package:flutter/material.dart';

class RangeSliderExample extends StatefulWidget {
  const RangeSliderExample({super.key});

  @override
  State<RangeSliderExample> createState() => _RangeSliderExampleState();
}

class _RangeSliderExampleState extends State<RangeSliderExample> {
  RangeValues _currentRangeValues = const RangeValues(20, 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range: \$${_currentRangeValues.start.round()} - \$${_currentRangeValues.end.round()}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        RangeSlider(
          values: _currentRangeValues,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '\$${_currentRangeValues.start.round()}',
            '\$${_currentRangeValues.end.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRangeValues = values;
            });
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Min Price',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  '\$${_currentRangeValues.start.round()}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Max Price',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(
                  '\$${_currentRangeValues.end.round()}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
