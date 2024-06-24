import 'dart:convert';

import 'package:lol_master_app/dao/config/lol_config_dao.dart';
import 'package:lol_master_app/entities/config/lol_config.dart';

class LolConfigDaoImpl extends LolConfigDao {
  LolConfigDaoImpl({required super.database});

  @override
  Future<LolConfig?> getCurrentConfig() async {
    try {
      List list = await database
          .rawQuery('SELECT * FROM LolConfig where configId=?', ["current"]);
      if (list.isEmpty) {
        return null;
      }
      var currentConfig = LolConfig.fromJson(jsonDecode(list.first["content"]));
      currentConfig.id = list.first["id"];
      currentConfig.configId = list.first["configId"];
      return currentConfig;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int?> updateCurrentConfig(LolConfig? lolConfig) async {
    if (lolConfig == null) {
      return null;
    }
    if (lolConfig.id == null) {
      //插入数据
      var id = await database.rawInsert(
          'INSERT INTO LolConfig(configId, content) VALUES(?,   ?)',
          ["current", jsonEncode(lolConfig.toJson())]);
      lolConfig.id = id;
      return id;
    } else {
      //更新数据
      return database.rawUpdate('UPDATE LolConfig SET content = ? WHERE id = ?',
          [jsonEncode(lolConfig.toJson()), lolConfig.id]);
    }
  }
}
