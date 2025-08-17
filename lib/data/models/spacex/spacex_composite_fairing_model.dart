import 'package:interesting_flutter/data/models/spacex/spacex_dimension_model.dart';

/// SpaceX Composite Fairing model
class SpaceXCompositeFairing {
  final SpaceXDimension? height;
  final SpaceXDimension? diameter;

  const SpaceXCompositeFairing({
    this.height,
    this.diameter,
  });

  factory SpaceXCompositeFairing.fromJson(Map<String, dynamic> json) {
    return SpaceXCompositeFairing(
      height: json['height'] != null
          ? SpaceXDimension.fromJson(json['height'])
          : null,
      diameter: json['diameter'] != null
          ? SpaceXDimension.fromJson(json['diameter'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height?.toJson(),
      'diameter': diameter?.toJson(),
    };
  }
}
