import 'package:lol_master_app/entities/hero/hero_base_attr.dart';
import 'package:lol_master_app/util/mvc.dart';

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

  void updateLevel(double value) {
    heroLevel = value.toInt();
    notifyListeners();
  }
}
