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
