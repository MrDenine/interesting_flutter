import 'package:interesting_flutter/data/models/spacex/spacex_headquarters_model.dart';

/// SpaceX Company model
class SpaceXCompany {
  final String name;
  final String founder;
  final int founded;
  final int employees;
  final int vehicles;
  final int launchSites;
  final int testSites;
  final String ceo;
  final String cto;
  final String coo;
  final String ctoPropulsion;
  final int valuation;
  final SpaceXHeadquarters? headquarters;
  final String summary;

  const SpaceXCompany({
    required this.name,
    required this.founder,
    required this.founded,
    required this.employees,
    required this.vehicles,
    required this.launchSites,
    required this.testSites,
    required this.ceo,
    required this.cto,
    required this.coo,
    required this.ctoPropulsion,
    required this.valuation,
    this.headquarters,
    required this.summary,
  });

  factory SpaceXCompany.fromJson(Map<String, dynamic> json) {
    return SpaceXCompany(
      name: json['name'] ?? '',
      founder: json['founder'] ?? '',
      founded: json['founded'] ?? 0,
      employees: json['employees'] ?? 0,
      vehicles: json['vehicles'] ?? 0,
      launchSites: json['launch_sites'] ?? 0,
      testSites: json['test_sites'] ?? 0,
      ceo: json['ceo'] ?? '',
      cto: json['cto'] ?? '',
      coo: json['coo'] ?? '',
      ctoPropulsion: json['cto_propulsion'] ?? '',
      valuation: json['valuation'] ?? 0,
      headquarters: json['headquarters'] != null
          ? SpaceXHeadquarters.fromJson(json['headquarters'])
          : null,
      summary: json['summary'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'founder': founder,
      'founded': founded,
      'employees': employees,
      'vehicles': vehicles,
      'launch_sites': launchSites,
      'test_sites': testSites,
      'ceo': ceo,
      'cto': cto,
      'coo': coo,
      'cto_propulsion': ctoPropulsion,
      'valuation': valuation,
      'headquarters': headquarters?.toJson(),
      'summary': summary,
    };
  }
}
