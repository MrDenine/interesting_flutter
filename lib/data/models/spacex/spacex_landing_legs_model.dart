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
