import 'package:lol_master_app/dao/base_dao.dart';

import '../../entities/equip/equip_config.dart';
import '../db_factory.dart';
import 'equip_dao_impl.dart';

abstract class EquipDao extends BaseDao {
  static EquipDao get instance =>
      EquipDaoImpl(database: MyDbFactory.instance.database);

  EquipDao({required super.database});

  Future<int> addEquipConfig(EquipConfig equipConfig);

  Future<int> deleteEquipConfig(EquipConfig equipConfig);

  Future<int> updateEquipConfig(EquipConfig equipConfig);

  Future<List<EquipConfig>> getEquipConfigList(String heroId);
}
