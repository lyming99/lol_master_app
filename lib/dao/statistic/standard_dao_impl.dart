import 'package:lol_master_app/entities/statistic/game_record.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';

import 'standard_dao.dart';

// 1.创建数据库连接(即打开数据库sqlite文件)
// 2.创建表
// 3.用连接进行增删改查
class StandardDaoImpl extends StandardDao {
  StandardDaoImpl({
    required super.database,
  });

  @override
  Future<int> deleteStandardRecord(StatisticStandardRecord record) async {
    return await database.delete(
      "StatisticStandardRecord",
      where: "id=?",
      whereArgs: [
        record.id,
      ],
    );
  }

  @override
  Future<List<StatisticStandardGroup>> getStandardGroupList() async {
    var items = await database.rawQuery("select * from StatisticStandardGroup");
    return items.map((e) => StatisticStandardGroup.fromJson(e)).toList();
  }

  @override
  Future<List<StatisticStandardItem>> getStandardItemList(int? groupId) async {
    var items = await database.rawQuery(
        "select * from StatisticStandardItem where groupId=?", [groupId]);
    return items.map((e) => StatisticStandardItem.fromJson(e)).toList();
  }

  @override
  Future<List<StatisticStandardRecord>> getStandardRecordList(
      String itemId) async {
    var items = await database.rawQuery(
        "select * from StatisticStandardRecord where standardItemId=?",
        [itemId]);
    return items.map((e) => StatisticStandardRecord.fromJson(e)).toList();
  }

  @override
  Future<List<StatisticStandardRecord>> getStandardRecordListByGameId(
      String gameId) async {
    var items = await database.rawQuery(
        "select * from StatisticStandardRecord where gameId=?", [gameId]);
    return items.map((e) => StatisticStandardRecord.fromJson(e)).toList();
  }

  @override
  Future<int> upsertStandardRecord(StatisticStandardRecord record) async {
    if (record.id != null) {
      return database.update(
        "StatisticStandardRecord",
        record.toJson(),
        where: "id=?",
        whereArgs: [
          record.id,
        ],
      );
    } else {
      var id = await database.insert(
        "StatisticStandardRecord",
        record.toJson(),
      );
      record.id = id;
      return id;
    }
  }

  @override
  Future<int> addStandardGroup(StatisticStandardGroup group) async {
    return database.insert(
      "StatisticStandardGroup",
      group.toJson(),
    );
  }

  @override
  Future<int> deleteStandardGroup(int? groupId) async {
    await database.delete(
      "StatisticStandardItem",
      where: "groupId=?",
      whereArgs: [
        groupId,
      ],
    );
    return database.delete(
      "StatisticStandardGroup",
      where: "id=?",
      whereArgs: [
        groupId,
      ],
    );
  }

  @override
  Future<int> updateStandardGroup(StatisticStandardGroup group) async {
    return database.update(
      "StatisticStandardGroup",
      group.toJson(),
      where: "id=?",
      whereArgs: [
        group.id,
      ],
    );
  }

  @override
  Future<int> deleteStandardItem(int? id) async {
    return database.delete(
      "StatisticStandardItem",
      where: "id=?",
      whereArgs: [
        id,
      ],
    );
  }

  @override
  Future<int> addStandardItem(StatisticStandardItem item) async {
    return database.insert(
      "StatisticStandardItem",
      item.toJson(),
    );
  }

  @override
  Future<int> updateStandardItem(StatisticStandardItem item) async {
    return database.update(
      "StatisticStandardItem",
      item.toJson(),
      where: "id=?",
      whereArgs: [
        item.id,
      ],
    );
  }

  @override
  Future<int> upsertGameRecord(GameRecord item) async {
    var ret = await database
        .query("GameRecord", where: "gameId=?", whereArgs: [item.gameId]);
    if (ret.isNotEmpty) {
      //更新数据
      return database.update(
        "GameRecord",
        item.toJson(),
        where: "gameId=?",
        whereArgs: [
          item.gameId,
        ],
      );
    } else {
      return database.insert(
        "GameRecord",
        item.toJson(),
      );
    }
  }

  @override
  Future<List<GameRecord>> getGameRecordList() async {
    var items = await database.rawQuery("select * from GameRecord");
    return items.map((e) => GameRecord.fromJson(e)).toList();
  }
}
