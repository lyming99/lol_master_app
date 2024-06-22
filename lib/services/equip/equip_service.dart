
import '../../entities/equip/equip_config.dart';

abstract class EquipService{
  Future<void> deleteEquipConfig(EquipConfig EquipConfig);
  Future<void> addEquipConfig(EquipConfig EquipConfig);
  Future<void> updateEquipConfig(EquipConfig EquipConfig);
  Future<List<EquipConfig>> getEquipConfigList(String heroId);
}