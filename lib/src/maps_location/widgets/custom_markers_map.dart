import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomMarkersMapExample extends StatefulWidget {
  const CustomMarkersMapExample({super.key});

  @override
  State<CustomMarkersMapExample> createState() =>
      _CustomMarkersMapExampleState();
}

class _CustomMarkersMapExampleState extends State<CustomMarkersMapExample>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  final List<MapLocation> _locations = [
    MapLocation(
      position: const LatLng(40.7589, -73.9851),
      name: 'Times Square',
      type: MarkerType.restaurant,
      description: 'Famous intersection in NYC',
    ),
    MapLocation(
      position: const LatLng(40.7614, -73.9776),
      name: 'Central Park',
      type: MarkerType.park,
      description: 'Large public park in Manhattan',
    ),
    MapLocation(
      position: const LatLng(40.7505, -73.9934),
      name: 'High Line',
      type: MarkerType.attraction,
      description: 'Elevated linear park',
    ),
    MapLocation(
      position: const LatLng(40.7484, -73.9857),
      name: 'Empire State Building',
      type: MarkerType.landmark,
      description: 'Art Deco skyscraper',
    ),
  ];

  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
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
                initialCenter: const LatLng(40.7589, -73.9851), // NYC
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedIndex = -1;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.interesting_flutter',
                ),
                MarkerLayer(
                  markers: _locations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final location = entry.value;
                    final isSelected = index == _selectedIndex;

                    return Marker(
                      point: location.position,
                      width: 60,
                      height: 60,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: isSelected ? _pulseAnimation.value : 1.0,
                              child: _buildCustomMarker(location, isSelected),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Location info panel
            if (_selectedIndex >= 0)
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          _getMarkerIcon(_locations[_selectedIndex].type),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _locations[_selectedIndex].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _locations[_selectedIndex].description,
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
                                _selectedIndex = -1;
                              });
                            },
                          ),
                        ],
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

  Widget _buildCustomMarker(MapLocation location, bool isSelected) {
    final color = _getMarkerColor(location.type);
    final icon = _getMarkerIcon(location.type);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Shadow/pulse effect
        Container(
          width: isSelected ? 60 : 40,
          height: isSelected ? 60 : 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        // Main marker
        Container(
          width: isSelected ? 45 : 30,
          height: isSelected ? 45 : 30,
          decoration: BoxDecoration(
            color: color,
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
            icon.icon,
            color: Colors.white,
            size: isSelected ? 20 : 15,
          ),
        ),
      ],
    );
  }

  Color _getMarkerColor(MarkerType type) {
    switch (type) {
      case MarkerType.restaurant:
        return Colors.red;
      case MarkerType.park:
        return Colors.green;
      case MarkerType.attraction:
        return Colors.blue;
      case MarkerType.landmark:
        return Colors.purple;
    }
  }

  Icon _getMarkerIcon(MarkerType type) {
    switch (type) {
      case MarkerType.restaurant:
        return const Icon(Icons.restaurant);
      case MarkerType.park:
        return const Icon(Icons.park);
      case MarkerType.attraction:
        return const Icon(Icons.attractions);
      case MarkerType.landmark:
        return const Icon(Icons.location_city);
    }
  }
}

class MapLocation {
  final LatLng position;
  final String name;
  final String description;
  final MarkerType type;

  MapLocation({
    required this.position,
    required this.name,
    required this.description,
    required this.type,
  });
}

enum MarkerType {
  restaurant,
  park,
  attraction,
  landmark,
}
