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


/// SpaceX Launch Site model
class SpaceXLaunchSite {
  final String siteId;
  final String siteName;
  final String? siteNameLong;

  const SpaceXLaunchSite({
    required this.siteId,
    required this.siteName,
    this.siteNameLong,
  });

  factory SpaceXLaunchSite.fromJson(Map<String, dynamic> json) {
    return SpaceXLaunchSite(
      siteId: json['site_id'] ?? '',
      siteName: json['site_name'] ?? '',
      siteNameLong: json['site_name_long'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'site_id': siteId,
      'site_name': siteName,
      'site_name_long': siteNameLong,
    };
  }
}

/// SpaceX Links model
class SpaceXLinks {
  final String? missionPatch;
  final String? missionPatchSmall;
  final String? articleLink;
  final String? videoLink;
  final String? wikipedia;
  final List<String>? flickrImages;

  const SpaceXLinks({
    this.missionPatch,
    this.missionPatchSmall,
    this.articleLink,
    this.videoLink,
    this.wikipedia,
    this.flickrImages,
  });

  factory SpaceXLinks.fromJson(Map<String, dynamic> json) {
    return SpaceXLinks(
      missionPatch: json['mission_patch'],
      missionPatchSmall: json['mission_patch_small'],
      articleLink: json['article_link'],
      videoLink: json['video_link'],
      wikipedia: json['wikipedia'],
      flickrImages: json['flickr_images'] != null
          ? List<String>.from(json['flickr_images'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mission_patch': missionPatch,
      'mission_patch_small': missionPatchSmall,
      'article_link': articleLink,
      'video_link': videoLink,
      'wikipedia': wikipedia,
      'flickr_images': flickrImages,
    };
  }
}

/// SpaceX Dimension model (height, diameter)
class SpaceXDimension {
  final double? meters;
  final double? feet;

  const SpaceXDimension({
    this.meters,
    this.feet,
  });

  factory SpaceXDimension.fromJson(Map<String, dynamic> json) {
    return SpaceXDimension(
      meters: json['meters']?.toDouble(),
      feet: json['feet']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meters': meters,
      'feet': feet,
    };
  }
}

/// SpaceX Mass model
class SpaceXMass {
  final int? kg;
  final int? lb;

  const SpaceXMass({
    this.kg,
    this.lb,
  });

  factory SpaceXMass.fromJson(Map<String, dynamic> json) {
    return SpaceXMass(
      kg: json['kg'],
      lb: json['lb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kg': kg,
      'lb': lb,
    };
  }
}

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

/// SpaceX ISP (Specific Impulse) model
class SpaceXIsp {
  final int? seaLevel;
  final int? vacuum;

  const SpaceXIsp({
    this.seaLevel,
    this.vacuum,
  });

  factory SpaceXIsp.fromJson(Map<String, dynamic> json) {
    return SpaceXIsp(
      seaLevel: json['sea_level'],
      vacuum: json['vacuum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sea_level': seaLevel,
      'vacuum': vacuum,
    };
  }
}

/// SpaceX Thrust model
class SpaceXThrust {
  final int? kN;
  final int? lbf;

  const SpaceXThrust({
    this.kN,
    this.lbf,
  });

  factory SpaceXThrust.fromJson(Map<String, dynamic> json) {
    return SpaceXThrust(
      kN: json['kN'],
      lbf: json['lbf'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kN': kN,
      'lbf': lbf,
    };
  }
}

/// SpaceX Landing Legs model
class SpaceXLandingLegs {
  final int? number;
  final String? material;

  const SpaceXLandingLegs({
    this.number,
    this.material,
  });

  factory SpaceXLandingLegs.fromJson(Map<String, dynamic> json) {
    return SpaceXLandingLegs(
      number: json['number'],
      material: json['material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'material': material,
    };
  }
}

/// SpaceX Rocket model
class SpaceXRocket {
  final String id;
  final String name;
  final String? type;
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
    required this.name,
    this.type,
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
      name: json['name'] ?? '',
      type: json['type'],
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
      engines:
          json['engines'] != null ? SpaceXEngines.fromJson(json['engines']) : null,
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
      'name': name,
      'type': type,
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
    return 'SpaceXRocket{id: $id, name: $name, active: $active, stages: $stages}';
  }
}

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

/// SpaceX Headquarters model
class SpaceXHeadquarters {
  final String address;
  final String city;
  final String state;

  const SpaceXHeadquarters({
    required this.address,
    required this.city,
    required this.state,
  });

  factory SpaceXHeadquarters.fromJson(Map<String, dynamic> json) {
    return SpaceXHeadquarters(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
    };
  }
}
