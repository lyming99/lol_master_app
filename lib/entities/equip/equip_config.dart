import 'equip_info.dart';

class EquipConfig {
  String? name;

  String? icon;

  List<EquipInfo>? startEquipList;
  List<EquipInfo>? primaryEquipList;
  List<EquipInfo>? secondaryEquipList;

  EquipConfig({
    this.name,
    this.icon,
    this.startEquipList,
    this.primaryEquipList,
    this.secondaryEquipList,
  });
}
