import 'package:interesting_flutter/data/models/spacex/spacex_isp_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_thrust_model.dart';

/// SpaceX Engines model
class SpaceXEngines {
  final int? number;
  final String? type;
  final String? version;
  final String? layout;
  final SpaceXIsp? isp;
  final int? engineLossMax;
  final String? propellant1;
  final String? propellant2;
  final SpaceXThrust? thrustSeaLevel;
  final SpaceXThrust? thrustVacuum;
  final double? thrustToWeight;

  const SpaceXEngines({
    this.number,
    this.type,
    this.version,
    this.layout,
    this.isp,
    this.engineLossMax,
    this.propellant1,
    this.propellant2,
    this.thrustSeaLevel,
    this.thrustVacuum,
    this.thrustToWeight,
  });

  factory SpaceXEngines.fromJson(Map<String, dynamic> json) {
    return SpaceXEngines(
      number: json['number'],
      type: json['type'],
      version: json['version'],
      layout: json['layout'],
      isp: json['isp'] != null ? SpaceXIsp.fromJson(json['isp']) : null,
      engineLossMax: json['engine_loss_max'],
      propellant1: json['propellant_1'],
      propellant2: json['propellant_2'],
      thrustSeaLevel: json['thrust_sea_level'] != null
          ? SpaceXThrust.fromJson(json['thrust_sea_level'])
          : null,
      thrustVacuum: json['thrust_vacuum'] != null
          ? SpaceXThrust.fromJson(json['thrust_vacuum'])
          : null,
      thrustToWeight: json['thrust_to_weight']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'type': type,
      'version': version,
      'layout': layout,
      'isp': isp?.toJson(),
      'engine_loss_max': engineLossMax,
      'propellant_1': propellant1,
      'propellant_2': propellant2,
      'thrust_sea_level': thrustSeaLevel?.toJson(),
      'thrust_vacuum': thrustVacuum?.toJson(),
      'thrust_to_weight': thrustToWeight,
    };
  }
}
