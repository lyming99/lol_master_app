import 'package:lol_master_app/dao/equip/equip_dao.dart';

import '../../entities/equip/equip_config.dart';
import 'equip_service.dart';

class EquipServiceImpl extends EquipService {
  var equipDao = EquipDao.instance;

  @override
  Future<void> addEquipConfig(EquipConfig equipConfig) async {
    equipDao.addEquipConfig(equipConfig);
  }

  @override
  Future<void> deleteEquipConfig(EquipConfig equipConfig) async {
    equipDao.deleteEquipConfig(equipConfig);
  }

  @override
  Future<List<EquipConfig>> getEquipConfigList(String heroId) async {
    return equipDao.getEquipConfigList(heroId);
  }

  @override
  Future<void> updateEquipConfig(EquipConfig equipConfig) async {
    if (equipConfig.id != null && equipConfig.id != -1) {
      await equipDao.updateEquipConfig(equipConfig);
    } else {
      await addEquipConfig(equipConfig);
    }
  }

  /// 应用符文到LOL客户端
  Future<void> applyToLolClient(EquipConfig equipConfig) async {}
}
