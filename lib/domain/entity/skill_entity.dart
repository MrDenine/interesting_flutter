class SkillEntity {
  final String skillCode;
  final String skillType;
  final int skillLevel;
  final String name;
  final String? description;

  SkillEntity({
    required this.skillCode,
    required this.skillType,
    required this.skillLevel,
    required this.name,
    this.description,
  });

  //copy with
  SkillEntity copyWith({
    String? skillCode,
    String? skillType,
    int? skillLevel,
    String? name,
    String? description,
  }) {
    return SkillEntity(
      skillCode: skillCode ?? this.skillCode,
      skillType: skillType ?? this.skillType,
      skillLevel: skillLevel ?? this.skillLevel,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'SkillEntity{skillCode: $skillCode, skillType: $skillType, skillLevel: $skillLevel, name: $name, description: $description}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SkillEntity &&
        other.skillCode == skillCode &&
        other.skillType == skillType &&
        other.skillLevel == skillLevel;
  }

  @override
  int get hashCode {
    return skillCode.hashCode ^ skillType.hashCode ^ skillLevel.hashCode;
  }
}
