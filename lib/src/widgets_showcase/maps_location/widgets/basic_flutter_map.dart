import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BasicFlutterMapExample extends StatefulWidget {
  const BasicFlutterMapExample({super.key});

  @override
  State<BasicFlutterMapExample> createState() => _FlutterMapExampleState();
}

class _FlutterMapExampleState extends State<BasicFlutterMapExample> {
  late final MapController _mapController;

  // Sample locations for markers
  final List<LatLng> _markerLocations = [
    const LatLng(51.509364, -0.128928), // London
    const LatLng(48.8566, 2.3522), // Paris
    const LatLng(52.5200, 13.4050), // Berlin
    const LatLng(41.9028, 12.4964), // Rome
    const LatLng(40.4168, -3.7038), // Madrid
  ];

  final List<String> _markerLabels = [
    'London',
    'Paris',
    'Berlin',
    'Rome',
    'Madrid',
  ];

  int _selectedMarkerIndex = -1;
  double _currentZoom = 6.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
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
                initialCenter: const LatLng(50.0, 10.0), // Center of Europe
                initialZoom: _currentZoom,
                minZoom: 3.0,
                maxZoom: 18.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedMarkerIndex = -1;
                  });
                },
              ),
              children: [
                // Tile layer with OpenStreetMap
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.interesting_flutter',
                  maxZoom: 19,
                ),

                // Marker layer
                MarkerLayer(
                  markers: _markerLocations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final location = entry.value;
                    final isSelected = index == _selectedMarkerIndex;

                    return Marker(
                      point: location,
                      width: isSelected ? 60 : 40,
                      height: isSelected ? 60 : 40,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMarkerIndex = index;
                          });
                          _mapController.move(location, _currentZoom);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.red
                                : Colors.blue.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: isSelected ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: isSelected ? 30 : 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Polyline layer to connect cities
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _markerLocations,
                      strokeWidth: 2,
                      color: Colors.blue.withValues(alpha: 0.6),
                      isDotted: true,
                    ),
                  ],
                ),
              ],
            ),

            // Map controls overlay
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildMapControlButton(
                    icon: Icons.add,
                    onPressed: () {
                      _currentZoom = (_currentZoom + 1).clamp(3.0, 18.0);
                      _mapController.move(
                          _mapController.camera.center, _currentZoom);
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildMapControlButton(
                    icon: Icons.remove,
                    onPressed: () {
                      _currentZoom = (_currentZoom - 1).clamp(3.0, 18.0);
                      _mapController.move(
                          _mapController.camera.center, _currentZoom);
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildMapControlButton(
                    icon: Icons.my_location,
                    onPressed: () {
                      _mapController.move(const LatLng(50.0, 10.0), 6.0);
                      setState(() {
                        _currentZoom = 6.0;
                        _selectedMarkerIndex = -1;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Selected marker info
            if (_selectedMarkerIndex >= 0)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_city,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _markerLabels[_selectedMarkerIndex],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_markerLocations[_selectedMarkerIndex].latitude.toStringAsFixed(4)}, ${_markerLocations[_selectedMarkerIndex].longitude.toStringAsFixed(4)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedMarkerIndex = -1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
