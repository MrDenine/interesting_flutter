import 'package:interesting_flutter/data/models/spacex/spacex_composite_fairing_model.dart';

/// SpaceX Payloads model
class SpaceXPayloads {
  final String? option1;
  final SpaceXCompositeFairing? compositeFairing;

  const SpaceXPayloads({
    this.option1,
    this.compositeFairing,
  });

  factory SpaceXPayloads.fromJson(Map<String, dynamic> json) {
    return SpaceXPayloads(
      option1: json['option_1'],
      compositeFairing: json['composite_fairing'] != null
          ? SpaceXCompositeFairing.fromJson(json['composite_fairing'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option_1': option1,
      'composite_fairing': compositeFairing?.toJson(),
    };
  }
}
