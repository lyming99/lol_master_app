import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lol_master_app/entities/hero/hero_base_attr.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/entities/hero/hero_spell.dart';

import 'hero_service.dart';

class HeroServiceImpl implements HeroService {
  List<HeroInfo>? heroList;

  Future<Map<String, HeroInfo>> getHeroPositionInfo() async {
    var positionJsonStr =
        await rootBundle.loadString("assets/lol/data/heroPosition.json");
    var keysJsonStr =
        await rootBundle.loadString("assets/lol/data/heroKeys.json");
    var posJson = jsonDecode(positionJsonStr);
    var posMap = posJson["list"] as Map;
    var keysJson = jsonDecode(keysJsonStr) as List;
    var result = <String, HeroInfo>{};
    for (var keyJson in keysJson) {
      var hero = HeroInfo();
      var heroId = keyJson["heroId"] as String;
      var pos = posMap[heroId];
      if (pos != null) {
        hero.roadType = (pos as Map).keys.map((e) {
          if (e == "top") {
            return "上路";
          }
          if (e == "mid") {
            return "中路";
          }
          if (e == "jungle") {
            return "打野";
          }
          if (e == "support") {
            return "辅助";
          }
          if (e == "bottom") {
            return "下路";
          }
          return "";
        }).join(",");
      }
      hero.searchKey = keyJson["keywords"];
      hero.id = keyJson["alias"];
      result[keyJson["alias"]] = hero;
    }
    return result;
  }

  @override
  Future<List<HeroInfo>> getHeroList() async {
    if (heroList == null) {
      var heroPositionMap = await getHeroPositionInfo();
      var jsonStr =
          await rootBundle.loadString("assets/lol/data/champion.json");
      var heroJson = jsonDecode(jsonStr);
      var heroMap = heroJson["data"] as Map;
      var heroList = <HeroInfo>[];
      for (var heroItem in heroMap.values) {
        var id = heroItem["id"] as String;
        var name = heroItem["name"] as String;
        var nickname = heroItem["title"] as String;
        var attr = HeroBaseAttr.fromJson(heroItem["stats"]);
        heroList.add(
          HeroInfo(
            heroId: heroItem["key"],
            name: name,
            nickname: nickname,
            iconUrl: "assets/lol/img/champion/$id.png",
            baseAttr: attr,
            searchKey: heroPositionMap[id]?.searchKey ?? "$name,$nickname",
            roadType: heroPositionMap[id]?.roadType,
          ),
        );
      }
      this.heroList = heroList;
    }
    return heroList!;
  }

  @override
  Future<bool> favoriteHero(HeroInfo hero) async {
    return false;
  }

  @override
  Future<List<HeroSpell>> getHeroSpell(String id) {
    // TODO: implement getHeroSpell
    throw UnimplementedError();
  }

  @override
  Future<String?> getHeroIcon(String? heroId) async {
    if (heroId == null) {
      return null;
    }
    var list = await getHeroList();
    var first = list.where((element) => element.heroId == heroId).firstOrNull;
    return first?.iconUrl;
  }

  @override
  Future<HeroInfo?> getHeroInfo(String? heroId) async {
    if (heroId == null) {
      return null;
    }
    var list = await getHeroList();
    return list.where((element) => element.heroId == heroId).firstOrNull;
  }
}
