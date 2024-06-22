import 'dart:convert';

import 'package:lol_master_app/dao/equip/equip_dao.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';

class EquipDaoImpl extends EquipDao {
  EquipDaoImpl({
    required super.database,
  });

  @override
  Future<int> addEquipConfig(EquipConfig equipConfig) async {
    return database.transaction((txn) async {
      var id = await txn.rawInsert(
          'INSERT INTO EquipConfig(name, heroId, content) VALUES(?, ?, ?)', [
        equipConfig.name,
        equipConfig.heroId ?? "",
        jsonEncode(equipConfig.toJson())
      ]);
      equipConfig.id = id;
      return id;
    });
  }

  @override
  Future<int> deleteEquipConfig(EquipConfig equipConfig) async {
    return database.rawDelete(
        'DELETE FROM EquipConfig WHERE id = ?', [equipConfig.id ?? -1]);
  }

  @override
  Future<List<EquipConfig>> getEquipConfigList(String heroId) async {
    List<Map> list;
    if (heroId == "") {
      list = await database.rawQuery('SELECT * FROM EquipConfig');
    } else {
      list = await database
          .rawQuery('SELECT * FROM EquipConfig WHERE heroId = ?', [heroId]);
    }
    return list.map((mapItem) {
      return EquipConfig.fromJson(jsonDecode(mapItem["content"]))
        ..id = mapItem["id"];
    }).toList();
  }

  @override
  Future<int> updateEquipConfig(EquipConfig equipConfig) async {
    return database.rawUpdate(
        'UPDATE EquipConfig SET name = ?, content = ?,heroId=? WHERE id = ?', [
      equipConfig.name,
      jsonEncode(equipConfig.toJson()),
      equipConfig.heroId,
      equipConfig.id ?? -1
    ]);
  }
}
