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
}
