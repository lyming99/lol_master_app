import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/hero/hero_base_attr.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_detail_view.dart';

import 'desk_hero_detail_controller.dart';

class HeroAttr {
  String? name;
  String? value;

  HeroAttr({
    this.name,
    this.value,
  });
}

/// 英雄属性控制器
class DeskHeroBaseAttrController extends MvcController {
  DeskHeroDetailController? heroDetailController;

  List<HeroAttr> heroAttrs = [
    HeroAttr(name: "攻击力", value: "91"),
    HeroAttr(name: "攻击速度", value: "0.77"),
    HeroAttr(name: "攻击距离", value: "125"),
    HeroAttr(name: "移动速度", value: "350"),
    HeroAttr(name: "生命值", value: "1240"),
    HeroAttr(name: "魔法值", value: "566"),
    HeroAttr(name: "护甲值", value: "56.0"),
    HeroAttr(name: "魔抗值", value: "42.3"),
  ];
  int heroLevel = 1;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    heroDetailController =
        context.findAncestorWidgetOfExactType<DeskHeroDetailView>()?.controller;
    updateLevel(1);
  }

  /// 调节等级，根据等级和成长值计算英雄的属性
  void updateLevel(double value) {
    heroLevel = value.toInt();
    var heroInfo = heroDetailController?.hero;
    if (heroInfo == null) {
      return;
    }
    var baseAttr = heroInfo.baseAttr;
    if (baseAttr == null) {
      return;
    }
    heroAttrs = [
      HeroAttr(
          name: "攻击力",
          value:
              "${(baseAttr.attackdamage + baseAttr.attackdamageperlevel * (heroLevel - 1)).floor()}"),
      HeroAttr(name: "攻击范围", value: "${baseAttr.attackrange}"),
      HeroAttr(
          name: "暴击率",
          value:
              "${(baseAttr.crit + baseAttr.critperlevel * (heroLevel - 1))}"),
      HeroAttr(
          name: "攻击速度",
          value: (baseAttr.attackspeed +
                  (baseAttr.attackspeed *
                      baseAttr.attackspeedperlevel /
                      100 *
                      (heroLevel - 1)))
              .toStringAsFixed(3)),
      HeroAttr(name: "移动速度", value: "${baseAttr.movespeed}"),
      HeroAttr(
          name: "生命值",
          value:
              "${(baseAttr.hp + baseAttr.hpperlevel * (heroLevel - 1)).toInt()}"),
      HeroAttr(
          name: "生命回复",
          value: (baseAttr.hpregen + baseAttr.hpregenperlevel * (heroLevel - 1))
              .toStringAsFixed(2)),
      HeroAttr(
          name: "魔法值",
          value:
              "${(baseAttr.mp + baseAttr.mpperlevel * (heroLevel - 1)).toInt()}"),
      HeroAttr(
          name: "魔法回复",
          value: (baseAttr.mpregen + baseAttr.mpregenperlevel * (heroLevel - 1))
              .toStringAsFixed(1)),
      HeroAttr(
          name: "护甲值",
          value:
              "${(baseAttr.armor + baseAttr.armorperlevel * (heroLevel - 1)).toInt()}"),
      HeroAttr(
          name: "魔抗值",
          value:
              "${(baseAttr.spellblock + baseAttr.spellblockperlevel * (heroLevel - 1)).toInt()}"),
    ];
    notifyListeners();
  }
}
