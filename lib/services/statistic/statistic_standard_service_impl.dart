import 'dart:convert';

import 'package:lol_master_app/dao/statistic/standard_dao.dart';
import 'package:lol_master_app/entities/lol/game_info.dart';
import 'package:lol_master_app/entities/statistic/game_record.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';

import '../rune/rune_service.dart';
import 'statistic_standard_service.dart';

class StatisticStandardServiceImpl extends StatisticStandardService {
  @override
  Future<void> deleteGroup(int? id) {
    return StandardDao.instance.deleteStandardGroup(id);
  }

  @override
  Future<List<StatisticStandardGroup>> getStandardGroupList(
      [bool queryItem = false]) async {
    var resp = await StandardDao.instance.getStandardGroupList();
    if (queryItem) {
      for (var value in resp) {
        var items = await getStandardItemList(value.id);
        value.items = items;
      }
    }
    return resp;
  }

  @override
  Future<List<StatisticStandardItem>> getStandardItemList(int? groupId) async {
    var resp = await StandardDao.instance.getStandardItemList(groupId);
    return resp;
  }

  @override
  Future<List<StatisticStandardRecord>> getStandardRecordList(
      String itemId) async {
    var resp = await StandardDao.instance.getStandardRecordList(itemId);
    return resp;
  }

  @override
  Future<List<StatisticStandardRecord>> getStandardRecordListByGameId(
      String gameId) async {
    var resp = await StandardDao.instance.getStandardRecordListByGameId(gameId);
    return resp;
  }

  @override
  Future<void> upsertStandardRecord(StatisticStandardRecord record) async {
    await StandardDao.instance.upsertStandardRecord(record);
  }

  Future<void> deleteGroupSet(List<StatisticStandardGroup> groupList) async {
    var tableGroupList = await getStandardGroupList();
    var oldIdSet = tableGroupList.map((e) => e.id).toSet();
    var newIdSet = groupList.map((e) => e.id).toSet();
    var deleteIdSet = oldIdSet.difference(newIdSet);
    for (var id in deleteIdSet) {
      await StandardDao.instance.deleteStandardGroup(id);
    }
  }

  Future<void> deleteItemSet(
      int? groupId, List<StatisticStandardItem> itemList) async {
    var tableItemList = await getStandardItemList(groupId);
    var oldIdSet = tableItemList.map((e) => e.id).toSet();
    var newIdSet = itemList.map((e) => e.id).toSet();
    var deleteIdSet = oldIdSet.difference(newIdSet);
    for (var id in deleteIdSet) {
      await StandardDao.instance.deleteStandardItem(id);
    }
  }

  @override
  Future<void> save(List<StatisticStandardGroup> groupList) async {
    await deleteGroupSet(groupList);

    /// 保存所有配置
    /// 1.删除已经删除的配置项目
    for (var group in groupList) {
      if (group.id != null) {
        /// 删除已经删除的配置项目
        await StandardDao.instance.updateStandardGroup(group);
      } else {
        /// 保存新增的配置项目
        await StandardDao.instance.addStandardGroup(group);
      }
      await deleteItemSet(group.id, group.items);
      for (var item in group.items) {
        if (item.id != null) {
          // 更新
          await StandardDao.instance.updateStandardItem(item);
        } else {
          // 写入
          await StandardDao.instance.addStandardItem(item);
        }
      }
    }
  }

  @override
  Future<void> recordGameInfo(List<HistoryInfo>? historyList) async {
    if (historyList == null) {
      return;
    }
    for (var history in historyList) {
      if (history.getGameTypeStr() != "单双排") {
        continue;
      }
      var json = await LolApi.instance.queryGameDetailInfo(history.gameId);
      if (json == null) {
        continue;
      }
      var participantIdentities = json["participantIdentities"];
      var participants = json["participants"];
      for (var item in participants) {
        var first = participantIdentities.where((element) {
          return element["participantId"] == item["participantId"];
        }).first;
        var puuid = first["player"]["puuid"];
        var summonerId = first["player"]["summonerId"];
        if (summonerId != history.summonerId) {
          continue;
        }
        var primaryRune = item["stats"]["perkPrimaryStyle"]?.toString();
        var secondaryRune = item["stats"]["perkSubStyle"]?.toString();
        //根据perkPrimaryStyle得到符文图片
        var spell1Id = item["spell1Id"]?.toString();
        var spell2Id = item["spell2Id"]?.toString();
        await RuneService.instance.getSummonerSpell(spell1Id);
        var isWin = item["stats"]["win"];
        json["win"] = isWin;
        json["heroId"] = item["championId"];
        var gameRecord = GameRecord();
        gameRecord.puuid = puuid;
        gameRecord.gameId = history.gameId.toString();
        gameRecord.gameType = "单双排";
        gameRecord.gameTime = history.gameDate;
        gameRecord.gameDuration = history.gameDuration;
        gameRecord.totalDamageDealtToChampions =
            item["stats"]["totalDamageDealtToChampions"];
        gameRecord.totalDamageDealtToChampionsPercent =
            item["stats"]["totalDamageDealtToChampionsPercent"];
        gameRecord.totalDamageTaken = item["stats"]["totalDamageTaken"];
        gameRecord.totalDamageTakenPercent =
            item["stats"]["totalDamageTakenPercent"];
        gameRecord.kills = item["stats"]["kills"];
        gameRecord.deaths = item["stats"]["deaths"];
        gameRecord.assists = item["stats"]["assists"];
        // 补兵：totalMinionsKilled
        gameRecord.creepScore = item["stats"]["totalMinionsKilled"];
        gameRecord.spell1 = spell1Id;
        gameRecord.spell2 = spell2Id;
        gameRecord.primaryRune = primaryRune;
        gameRecord.secondaryRune = secondaryRune;
        gameRecord.content = jsonEncode(json);
        var rankInfo = await LolApi.instance.queryRankInfo(puuid);
        if (rankInfo != null) {
          gameRecord.rankLevel1 = LolApi.instance.getRankLevel1Str(
              rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["tier"]);
          gameRecord.rankLevel2 = LolApi.instance.getRankLevel2Str(
              rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["division"]);
        }
        await StandardDao.instance.upsertGameRecord(gameRecord);
      }
    }
  }

  @override
  Future<List<GameRecord>> getGameRecordList() async {
    var resp = await StandardDao.instance.getGameRecordList();
    var config = await LolConfigService.instance.getCurrentConfig();
    var puuid = config?.currentPuuid;
    if (puuid == null) {
      puuid = await LolApi.instance.getCurrentSummonerPuuid();
      config?.currentPuuid = puuid;
      await LolConfigService.instance.updateCurrentConfig(config);
    }
    return resp.where((element) => element.puuid == puuid).toList();
  }

  @override
  Future<String?> getGameNote(String? gameId) {
    return StandardDao.instance.getGameNote(gameId);
  }

  @override
  Future<int?> setGameNote(String? gameId, String? gameNote) {
    return StandardDao.instance.setGameNote(gameId, gameNote);
  }
}
