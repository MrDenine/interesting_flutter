import 'package:interesting_flutter/data/models/spacex/spacex_payloads_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_thrust_model.dart';

/// SpaceX Second Stage model
class SpaceXSecondStage {
  final bool? reusable;
  final int? engines;
  final double? fuelAmountTons;
  final int? burnTimeSec;
  final SpaceXThrust? thrust;
  final SpaceXPayloads? payloads;

  const SpaceXSecondStage({
    this.reusable,
    this.engines,
    this.fuelAmountTons,
    this.burnTimeSec,
    this.thrust,
    this.payloads,
  });

  factory SpaceXSecondStage.fromJson(Map<String, dynamic> json) {
    return SpaceXSecondStage(
      reusable: json['reusable'],
      engines: json['engines'],
      fuelAmountTons: json['fuel_amount_tons']?.toDouble(),
      burnTimeSec: json['burn_time_sec'],
      thrust:
          json['thrust'] != null ? SpaceXThrust.fromJson(json['thrust']) : null,
      payloads: json['payloads'] != null
          ? SpaceXPayloads.fromJson(json['payloads'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reusable': reusable,
      'engines': engines,
      'fuel_amount_tons': fuelAmountTons,
      'burn_time_sec': burnTimeSec,
      'thrust': thrust?.toJson(),
      'payloads': payloads?.toJson(),
    };
  }
}
