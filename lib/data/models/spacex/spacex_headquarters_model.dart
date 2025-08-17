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
