import 'package:interesting_flutter/data/models/spacex/spacex_dimension_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_engines_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_landing_legs_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_mass_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_payload_weight_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_second_stage_model.dart';

/// SpaceX Rocket model
class SpaceXRocket {
  final String id;
  final String rocketName;
  final String? rocketType;
  final bool? active;
  final int? stages;
  final int? boosters;
  final int? costPerLaunch;
  final double? successRatePct;
  final String? firstFlight;
  final String? country;
  final String? company;
  final SpaceXDimension? height;
  final SpaceXDimension? diameter;
  final SpaceXMass? mass;
  final List<SpaceXPayloadWeight>? payloadWeights;
  final SpaceXFirstStage? firstStage;
  final SpaceXSecondStage? secondStage;
  final SpaceXEngines? engines;
  final SpaceXLandingLegs? landingLegs;
  final List<String>? flickrImages;
  final String? wikipedia;
  final String? description;

  const SpaceXRocket({
    required this.id,
    required this.rocketName,
    this.rocketType,
    this.active,
    this.stages,
    this.boosters,
    this.costPerLaunch,
    this.successRatePct,
    this.firstFlight,
    this.country,
    this.company,
    this.height,
    this.diameter,
    this.mass,
    this.payloadWeights,
    this.firstStage,
    this.secondStage,
    this.engines,
    this.landingLegs,
    this.flickrImages,
    this.wikipedia,
    this.description,
  });

  factory SpaceXRocket.fromJson(Map<String, dynamic> json) {
    return SpaceXRocket(
      id: json['id'] ?? '',
      rocketName: json['rocket_name'] ?? '',
      rocketType: json['rocket_type'],
      active: json['active'],
      stages: json['stages'],
      boosters: json['boosters'],
      costPerLaunch: json['cost_per_launch'],
      successRatePct: json['success_rate_pct']?.toDouble(),
      firstFlight: json['first_flight'],
      country: json['country'],
      company: json['company'],
      height: json['height'] != null
          ? SpaceXDimension.fromJson(json['height'])
          : null,
      diameter: json['diameter'] != null
          ? SpaceXDimension.fromJson(json['diameter'])
          : null,
      mass: json['mass'] != null ? SpaceXMass.fromJson(json['mass']) : null,
      payloadWeights: json['payload_weights'] != null
          ? (json['payload_weights'] as List)
              .map((e) => SpaceXPayloadWeight.fromJson(e))
              .toList()
          : null,
      firstStage: json['first_stage'] != null
          ? SpaceXFirstStage.fromJson(json['first_stage'])
          : null,
      secondStage: json['second_stage'] != null
          ? SpaceXSecondStage.fromJson(json['second_stage'])
          : null,
      engines: json['engines'] != null
          ? SpaceXEngines.fromJson(json['engines'])
          : null,
      landingLegs: json['landing_legs'] != null
          ? SpaceXLandingLegs.fromJson(json['landing_legs'])
          : null,
      flickrImages: json['flickr_images'] != null
          ? List<String>.from(json['flickr_images'])
          : null,
      wikipedia: json['wikipedia'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rocketName': rocketName,
      'rocketType': rocketType,
      'active': active,
      'stages': stages,
      'boosters': boosters,
      'cost_per_launch': costPerLaunch,
      'success_rate_pct': successRatePct,
      'first_flight': firstFlight,
      'country': country,
      'company': company,
      'height': height?.toJson(),
      'diameter': diameter?.toJson(),
      'mass': mass?.toJson(),
      'payload_weights': payloadWeights?.map((e) => e.toJson()).toList(),
      'first_stage': firstStage?.toJson(),
      'second_stage': secondStage?.toJson(),
      'engines': engines?.toJson(),
      'landing_legs': landingLegs?.toJson(),
      'flickr_images': flickrImages,
      'wikipedia': wikipedia,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'SpaceXRocket{id: $id, rocketName: $rocketName, active: $active, stages: $stages}';
  }
}
