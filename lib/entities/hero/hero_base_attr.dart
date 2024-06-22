class HeroBaseAttr {
  // 生命值
  int hp;
  int hpperlevel;
  // 魔法值
  int mp;
  double mpperlevel;
  // 移动速度
  int movespeed;
  // 护甲
  int armor;
  double armorperlevel;
  // 魔抗
  int spellblock;
  double spellblockperlevel;
  // 攻击范围
  int attackrange;
  // 生命回复
  double hpregen;
  double hpregenperlevel;
  // 魔法回复
  double mpregen;
  double mpregenperlevel;
  // 暴击
  int crit;
  int critperlevel;
  // 攻击力
  int attackdamage;
  double attackdamageperlevel;
  double attackspeedperlevel;
  double attackspeed;

  HeroBaseAttr({
    required this.hp,
    required this.hpperlevel,
    required this.mp,
    required this.mpperlevel,
    required this.movespeed,
    required this.armor,
    required this.armorperlevel,
    required this.spellblock,
    required this.spellblockperlevel,
    required this.attackrange,
    required this.hpregen,
    required this.hpregenperlevel,
    required this.mpregen,
    required this.mpregenperlevel,
    required this.crit,
    required this.critperlevel,
    required this.attackdamage,
    required this.attackdamageperlevel,
    required this.attackspeedperlevel,
    required this.attackspeed,
  });

  factory HeroBaseAttr.fromJson(Map<String, dynamic> json) {
    return HeroBaseAttr(
      hp: json['hp'],
      hpperlevel: json['hpperlevel'],
      mp: json['mp'],
      mpperlevel: json['mpperlevel'].toDouble(),
      movespeed: json['movespeed'],
      armor: json['armor'],
      armorperlevel: json['armorperlevel'].toDouble(),
      spellblock: json['spellblock'],
      spellblockperlevel: json['spellblockperlevel'].toDouble(),
      attackrange: json['attackrange'],
      hpregen: json['hpregen'].toDouble(),
      hpregenperlevel: json['hpregenperlevel'].toDouble(),
      mpregen: json['mpregen'].toDouble(),
      mpregenperlevel: json['mpregenperlevel'].toDouble(),
      crit: json['crit'],
      critperlevel: json['critperlevel'],
      attackdamage: json['attackdamage'],
      attackdamageperlevel: json['attackdamageperlevel'].toDouble(),
      attackspeedperlevel: json['attackspeedperlevel'].toDouble(),
      attackspeed: json['attackspeed'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hp': hp,
      'hpperlevel': hpperlevel,
      'mp': mp,
      'mpperlevel': mpperlevel,
      'movespeed': movespeed,
      'armor': armor,
      'armorperlevel': armorperlevel,
      'spellblock': spellblock,
      'spellblockperlevel': spellblockperlevel,
      'attackrange': attackrange,
      'hpregen': hpregen,
      'hpregenperlevel': hpregenperlevel,
      'mpregen': mpregen,
      'mpregenperlevel': mpregenperlevel,
      'crit': crit,
      'critperlevel': critperlevel,
      'attackdamage': attackdamage,
      'attackdamageperlevel': attackdamageperlevel,
      'attackspeedperlevel': attackspeedperlevel,
      'attackspeed': attackspeed,
    };
  }
}
