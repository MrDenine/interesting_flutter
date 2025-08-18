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
