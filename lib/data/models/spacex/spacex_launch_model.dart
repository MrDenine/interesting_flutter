import 'package:interesting_flutter/data/models/spacex/spacex_launch_site_model.dart';
import 'package:interesting_flutter/data/models/spacex/spacex_rocket_model.dart';

/// SpaceX Launch model
class SpaceXLaunch {
  final String id;
  final String missionName;
  final String? launchDateLocal;
  final bool? launchSuccess;
  final String? details;
  final SpaceXRocket? rocket;
  final SpaceXLaunchSite? launchSite;
  final SpaceXLinks? links;

  const SpaceXLaunch({
    required this.id,
    required this.missionName,
    this.launchDateLocal,
    this.launchSuccess,
    this.details,
    this.rocket,
    this.launchSite,
    this.links,
  });

  factory SpaceXLaunch.fromJson(Map<String, dynamic> json) {
    return SpaceXLaunch(
      id: json['id'] ?? '',
      missionName: json['mission_name'] ?? '',
      launchDateLocal: json['launch_date_local'],
      launchSuccess: json['launch_success'],
      details: json['details'],
      rocket:
          json['rocket'] != null ? SpaceXRocket.fromJson(json['rocket']) : null,
      launchSite: json['launch_site'] != null
          ? SpaceXLaunchSite.fromJson(json['launch_site'])
          : null,
      links: json['links'] != null ? SpaceXLinks.fromJson(json['links']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mission_name': missionName,
      'launch_date_local': launchDateLocal,
      'launch_success': launchSuccess,
      'details': details,
      'rocket': rocket?.toJson(),
      'launch_site': launchSite?.toJson(),
      'links': links?.toJson(),
    };
  }

  @override
  String toString() {
    return 'SpaceXLaunch{id: $id, missionName: $missionName, launchSuccess: $launchSuccess}';
  }
}
