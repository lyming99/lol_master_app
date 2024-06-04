// 英雄技能
class HeroSpell {
  String? id;

  // 英雄ID
  String? heroId;

  // 快捷键
  String? spellKey;

  // 技能名称
  String? name;

  // 技能图标
  String? description;

  // 技能描述
  String? abilityIconPath;

  // 技能视频
  String? abilityVideoPath;

  HeroSpell({
    this.id,
    this.heroId,
    this.spellKey,
    this.name,
    this.description,
    this.abilityIconPath,
    this.abilityVideoPath,
  });

  factory HeroSpell.fromJson(Map<String, dynamic> json) => HeroSpell(
        id: json["id"],
        heroId: json["heroId"],
        spellKey: json["spellKey"],
        name: json["name"],
        description: json["description"],
        abilityIconPath: json["abilityIconPath"],
        abilityVideoPath: json["abilityVideoPath"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heroId": heroId,
        "spellKey": spellKey,
        "name": name,
        "description": description,
        "abilityIconPath": abilityIconPath == null ? null : abilityIconPath,
        "abilityVideoPath": abilityVideoPath == null ? null : abilityVideoPath,
      };
}
