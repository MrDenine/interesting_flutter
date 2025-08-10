import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InteractiveMapExample extends StatefulWidget {
  const InteractiveMapExample({super.key});

  @override
  State<InteractiveMapExample> createState() => _InteractiveMapExampleState();
}

class _InteractiveMapExampleState extends State<InteractiveMapExample> {
  late final MapController _mapController;
  final List<LatLng> _tappedPoints = [];
  bool _measureMode = false;
  double _totalDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _onMapTap(TapPosition tapPosition, LatLng point) {
    if (_measureMode) {
      setState(() {
        _tappedPoints.add(point);
        if (_tappedPoints.length > 1) {
          _calculateTotalDistance();
        }
      });
    }
  }

  void _calculateTotalDistance() {
    double distance = 0.0;
    for (int i = 0; i < _tappedPoints.length - 1; i++) {
      distance += const Distance()
          .as(LengthUnit.Kilometer, _tappedPoints[i], _tappedPoints[i + 1]);
    }
    _totalDistance = distance;
  }

  void _clearMeasurements() {
    setState(() {
      _tappedPoints.clear();
      _totalDistance = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    const LatLng(37.7749, -122.4194), // San Francisco
                initialZoom: 10.0,
                onTap: _onMapTap,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.interesting_flutter',
                ),

                // Polyline for distance measurement
                if (_tappedPoints.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _tappedPoints,
                        strokeWidth: 3,
                        color: Colors.red,
                      ),
                    ],
                  ),

                // Markers for tapped points
                MarkerLayer(
                  markers: _tappedPoints.asMap().entries.map((entry) {
                    final index = entry.key;
                    final point = entry.value;

                    return Marker(
                      point: point,
                      width: 30,
                      height: 30,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Control panel
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _measureMode ? Icons.straighten : Icons.touch_app,
                          size: 16,
                          color: _measureMode ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _measureMode ? 'Measure Mode' : 'Tap to Enable',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _measureMode ? Colors.red : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    if (_totalDistance > 0) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Distance: ${_totalDistance.toStringAsFixed(2)} km',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Floating action buttons
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'measure',
                    onPressed: () {
                      setState(() {
                        _measureMode = !_measureMode;
                        if (!_measureMode) {
                          _clearMeasurements();
                        }
                      });
                    },
                    backgroundColor: _measureMode ? Colors.red : Colors.blue,
                    child: Icon(
                      _measureMode ? Icons.stop : Icons.straighten,
                      color: Colors.white,
                    ),
                  ),
                  if (_measureMode) ...[
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      heroTag: 'clear',
                      onPressed: _clearMeasurements,
                      backgroundColor: Colors.grey,
                      child: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
