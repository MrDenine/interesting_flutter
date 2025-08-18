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
