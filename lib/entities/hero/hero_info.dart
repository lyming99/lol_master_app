// 英雄
import 'hero_base_attr.dart';
import 'hero_combo.dart';
import 'hero_spell.dart';

class HeroInfo {
  // 英雄ID(英文名字)
  String? id;

  // 官方英雄id
  String? heroId;

  // 英雄名称
  String? name;

  // 英雄头像
  String? iconUrl;

  // 路线位置：上单、中单、打野、下路、辅助
  String? roadType;

  // 昵称：多个用逗号隔开
  String? nickname;

  // 是否收藏
  bool? favorite;

  // 基础属性
  HeroBaseAttr? baseAttr;

  // 技能列表
  List<HeroSpell>? skills;

  // 技能连招
  List<HeroCombo>? combos;

  // 搜索关键字
  String? searchKey;

  HeroInfo({
    this.id,
    this.heroId,
    this.name,
    this.iconUrl,
    this.roadType,
    this.nickname,
    this.favorite,
    this.baseAttr,
    this.skills,
    this.combos,
    this.searchKey,
  });

  factory HeroInfo.fromJson(Map<String, dynamic> json) => HeroInfo(
        id: json["id"],
        heroId: json["heroId"],
        name: json["name"],
        iconUrl: json["iconUrl"],
        roadType: json["roadType"],
        nickname: json["nickname"],
        favorite: json["favorite"],
        baseAttr: json["baseAttrs"] == null
            ? null
            : HeroBaseAttr.fromJson(json["baseAttrs"]),
        skills: json["skills"] == null
            ? null
            : List<HeroSpell>.from(
                json["skills"].map((x) => HeroSpell.fromJson(x))),
        combos: json["combos"] == null
            ? null
            : List<HeroCombo>.from(
                json["combos"].map((x) => HeroCombo.fromJson(x))),
        searchKey: json["searchKey"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heroId": heroId,
        "name": name,
        "iconUrl": iconUrl,
        "roadType": roadType,
        "nickname": nickname,
        "favorite": favorite,
        "baseAttrs": baseAttr?.toJson(),
        "skills": skills?.map((x) => x.toJson()).toList(),
        "combos": combos?.map((x) => x.toJson()).toList(),
        "searchKey": searchKey,
      };
}
