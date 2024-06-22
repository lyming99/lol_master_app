import 'equip_info.dart';

class EquipConfig {
  int? id;
  String? name;
  String? icon;
  String? heroId;
  List<EquipGroup> equipGroupList;

  EquipConfig({
    this.name,
    this.icon,
    this.heroId,
    required this.equipGroupList,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "icon": icon,
      "heroId": heroId,
      "equipGroupList": equipGroupList.map((e) => e.toJson()).toList(),
    };
  }

  factory EquipConfig.fromJson(Map<String, dynamic> json) {
    return EquipConfig(
      name: json["name"],
      icon: json["icon"],
      heroId: json["heroId"],
      equipGroupList: json["equipGroupList"]
          .map<EquipGroup>((e) => EquipGroup.fromJson(e))
          .toList(),
    );
  }
}

class EquipGroup {
  String? name;

  List<EquipInfo> equipList;

  EquipGroup({
    this.name,
    required this.equipList,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "equipList": equipList.map((e) => e.toJson()).toList(),
    };
  }

  factory EquipGroup.fromJson(Map<String, dynamic> json) {
    return EquipGroup(
      name: json["name"],
      equipList: json["equipList"]
          .map<EquipInfo>((e) => EquipInfo.fromJson(e))
          .toList(),
    );
  }
}
