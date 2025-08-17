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
