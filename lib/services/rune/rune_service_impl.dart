import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lol_master_app/dao/rune/rune_dao.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/rune/rune_service.dart';

class RuneServiceImpl extends RuneService {
  RuneDao runeDao = RuneDao.instance;
  var _runeIconMap = <String, String>{};
  var _spellIconMap = <String, String>{};

  @override
  Future<void> addRuneConfig(RuneConfig runeConfig) async {
    runeDao.addRuneConfig(runeConfig);
  }

  @override
  Future<void> deleteRuneConfig(RuneConfig runeConfig) async {
    runeDao.deleteRuneConfig(runeConfig);
  }

  @override
  Future<List<RuneConfig>> getRuneConfigList(String heroId) async {
    return runeDao.getRuneConfigList(heroId);
  }

  @override
  Future<void> updateRuneConfig(RuneConfig runeConfig) async {
    if (runeConfig.id != null && runeConfig.id != -1) {
      await runeDao.updateRuneConfig(runeConfig);
    } else {
      await addRuneConfig(runeConfig);
    }
  }

  /// 应用符文到LOL客户端
  Future<void> applyToLolClient(RuneConfig runeConfig) async {
    /// 1.读取客户端的key
    /// 2.将配置发送给客户端
    await LolApi.instance.putRune(runeConfig);
  }

  @override
  Future<String?> getRuneIcon(String? runeId) async {
    if (runeId == null) {
      return runeId;
    }
    if (_runeIconMap.containsKey(runeId)) {
      return _runeIconMap[runeId];
    }
    // rune_list.json
    var runeJson =
        await rootBundle.loadString("assets/lol/data/rune_list.json");
    var array = jsonDecode(runeJson)["rune"] as Map;
    for (var entry in array.entries) {
      if (entry.key == runeId) {
        var result = entry.value["icon"];
        if (result != null) {
          _runeIconMap[runeId] = result;
          return result;
        }
      }
    }
    return null;
  }

  @override
  Future<String?> getSummonerSpell(String? spellId) async {
    if (spellId == null) {
      return spellId;
    }
    if (_spellIconMap.containsKey(spellId)) {
      return _spellIconMap[spellId];
    }
    // rune_list.json
    var runeJson =
        await rootBundle.loadString("assets/lol/data/summonerSpell.json");
    var map = jsonDecode(runeJson)["summonerskill"] as Map;
    var icon = map[spellId]["icon"];
    if (icon != null) {
      _spellIconMap[spellId] = icon;
      return icon;
    }
    return null;
  }
}
