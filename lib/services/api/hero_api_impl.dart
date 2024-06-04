import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lol_master_app/entities/hero/hero_spell.dart';

import 'hero_api.dart';

class HeroApiImpl implements HeroApi {
  @override
  Future<List<HeroSpell>?> queryHeroSpells(String heroId) async {
    if (heroId.isEmpty) {
      return null;
    }
    String url = "https://game.gtimg.cn/images/lol/act/img/js/hero/$heroId.js";
    var resp = await Dio().get(url);
    if (resp.statusCode == 200) {
      var data = resp.data;
      if (data is String) {
        var json = jsonDecode(data);
        var spells = json["spells"];
        if (spells is List) {
          var result = spells.map((e) => HeroSpell.fromJson(e)).toList();
          var map = <String, HeroSpell>{};
          for (var item in result) {
            dealSpellInfo(item);
            var spellKey = item.spellKey;
            if (spellKey == null) {
              continue;
            }
            map[spellKey] = item;
          }
          return [map["被动"], map["Q"], map["W"], map["E"], map["R"]]
              .where((element) => element != null)
              .map((e) => e!)
              .toList();
        }
      }
    }
    return null;
  }

  void dealSpellInfo(HeroSpell item) {
    item.spellKey = dealSpellKey(item.spellKey);
    var videoPath = item.abilityVideoPath;
    if (videoPath == null) {
      return;
    }
    if (videoPath.endsWith(".webm")) {
      videoPath =
          "https://d28xe8vt774jo5.cloudfront.net/${videoPath.substring(0, videoPath.length - 4)}mp4";
      item.abilityVideoPath = videoPath;
    }
  }

  String? dealSpellKey(String? spellKey) {
    if (spellKey == null) {
      return null;
    }
    if (spellKey.startsWith("p")) {
      return "被动";
    }
    return spellKey.toUpperCase();
  }
}
