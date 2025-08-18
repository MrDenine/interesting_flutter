import 'package:interesting_flutter/data/models/spacex/spacex_thrust_model.dart';

/// SpaceX Payload Weight model
class SpaceXPayloadWeight {
  final String id;
  final String name;
  final int? kg;
  final int? lb;

  const SpaceXPayloadWeight({
    required this.id,
    required this.name,
    this.kg,
    this.lb,
  });

  factory SpaceXPayloadWeight.fromJson(Map<String, dynamic> json) {
    return SpaceXPayloadWeight(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      kg: json['kg'],
      lb: json['lb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kg': kg,
      'lb': lb,
    };
  }
}

/// SpaceX First Stage model
class SpaceXFirstStage {
  final bool? reusable;
  final int? engines;
  final double? fuelAmountTons;
  final int? burnTimeSec;
  final SpaceXThrust? thrustSeaLevel;
  final SpaceXThrust? thrustVacuum;

  const SpaceXFirstStage({
    this.reusable,
    this.engines,
    this.fuelAmountTons,
    this.burnTimeSec,
    this.thrustSeaLevel,
    this.thrustVacuum,
  });

  factory SpaceXFirstStage.fromJson(Map<String, dynamic> json) {
    return SpaceXFirstStage(
      reusable: json['reusable'],
      engines: json['engines'],
      fuelAmountTons: json['fuel_amount_tons']?.toDouble(),
      burnTimeSec: json['burn_time_sec'],
      thrustSeaLevel: json['thrust_sea_level'] != null
          ? SpaceXThrust.fromJson(json['thrust_sea_level'])
          : null,
      thrustVacuum: json['thrust_vacuum'] != null
          ? SpaceXThrust.fromJson(json['thrust_vacuum'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reusable': reusable,
      'engines': engines,
      'fuel_amount_tons': fuelAmountTons,
      'burn_time_sec': burnTimeSec,
      'thrust_sea_level': thrustSeaLevel?.toJson(),
      'thrust_vacuum': thrustVacuum?.toJson(),
    };
  }
}
