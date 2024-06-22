import 'dart:convert';

import 'package:lol_master_app/entities/rune/rune.dart';

import 'rune_dao.dart';

// 1.创建数据库连接(即打开数据库sqlite文件)
// 2.创建表
// 3.用连接进行增删改查
class RuneDaoImpl extends RuneDao {
  RuneDaoImpl({
    required super.database,
  });

  @override
  Future<int?> addRuneConfig(RuneConfig runeConfig) async {
    return await database.transaction((txn) async {
      var id = await txn.rawInsert(
          'INSERT INTO RuneConfig(name, heroId, content) VALUES(?, ?, ?)', [
        runeConfig.configName,
        runeConfig.heroId ?? "",
        jsonEncode(runeConfig.toJson())
      ]);
      runeConfig.id = id;
      return id;
    });
  }

  @override
  Future<int?> updateRuneConfig(RuneConfig runeConfig) async {
    return await database.rawUpdate(
        'UPDATE RuneConfig SET name = ?, content = ?,heroId=? WHERE id = ?', [
      runeConfig.configName,
      jsonEncode(runeConfig.toJson()),
      runeConfig.heroId,
      runeConfig.id ?? -1
    ]);
  }

  @override
  Future<void> deleteRuneConfig(RuneConfig runeConfig) async {
    await database.rawDelete(
        'DELETE FROM RuneConfig WHERE id = ?', [runeConfig.id ?? -1]);
  }

  @override
  Future<List<RuneConfig>> getRuneConfigList(String heroId) async {
    // Get the records
    List<Map> list;
    if (heroId == "") {
      list = await database.rawQuery('SELECT * FROM RuneConfig');
    } else {
      list = await database
          .rawQuery('SELECT * FROM RuneConfig WHERE heroId = ?', [heroId]);
    }
    return list.map((mapItem) {
      return RuneConfig.fromJson(jsonDecode(mapItem["content"]))
        ..id = mapItem["id"];
    }).toList();
  }
}
