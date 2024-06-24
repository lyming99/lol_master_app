class RuneGroupItem {
  String? key;
  String? name;
  String? desc;
  String? icon;
  String? itemIcon;
  String? bgIcon;
  bool? selected;
  List<List<RuneConfigItem>> runes = [];

  RuneGroupItem({
    this.key,
    this.name,
    this.desc,
    this.icon,
    this.itemIcon,
    this.bgIcon,
    this.selected,
  });

  // copy
  RuneGroupItem copy() {
    var copy = RuneGroupItem(
      key: key,
      name: name,
      desc: desc,
      icon: icon,
      itemIcon: itemIcon,
      bgIcon: bgIcon,
    );
    copy.runes = runes.map((e) => e.map((e) => e.copy()).toList()).toList();
    return copy;
  }
}

class RuneConfigItem {
  String? key;
  String? name;
  String? desc;
  String? icon;
  bool? selected;
  int selectTime = 0;

  RuneConfigItem({
    this.key,
    this.name,
    this.desc,
    this.icon,
    this.selected,
  });

  // copy
  RuneConfigItem copy() {
    return RuneConfigItem(
      key: key,
      name: name,
      desc: desc,
      icon: icon,
    );
  }

  factory RuneConfigItem.fromJson(Map<String, dynamic> json) {
    return RuneConfigItem(
      key: json["key"],
      name: json["name"],
      desc: json["desc"],
      icon: json["icon"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "name": name,
      "desc": desc,
      "icon": icon,
    };
  }
}

class RuneConfig {
  int? id;

  // 英雄英文id
  String? heroId;
  String? configName;
  String? primaryRuneKey;
  String? secondaryRuneKey;
  List<RuneConfigItem>? primaryRunes;
  List<RuneConfigItem>? secondaryRunes;
  List<RuneConfigItem>? thirdRunes;

  RuneConfig({
    this.id,
    this.heroId,
    this.configName,
    this.primaryRuneKey,
    this.secondaryRuneKey,
    this.primaryRunes,
    this.secondaryRunes,
    this.thirdRunes,
  });

  // from json
  factory RuneConfig.fromJson(Map<String, dynamic> json) {
    return RuneConfig(
      primaryRunes: json["primaryRunes"] == null
          ? null
          : (json["primaryRunes"] as List)
              .map((e) => RuneConfigItem.fromJson(e))
              .toList(),
      secondaryRunes: json["secondaryRunes"] == null
          ? null
          : (json["secondaryRunes"] as List)
              .map((e) => RuneConfigItem.fromJson(e))
              .toList(),
      thirdRunes: json["thirdRunes"] == null
          ? null
          : (json["thirdRunes"] as List)
              .map((e) => RuneConfigItem.fromJson(e))
              .toList(),
      primaryRuneKey: json["primaryRuneKey"],
      secondaryRuneKey: json["secondaryRuneKey"],
      configName: json["configName"],
      heroId: json["heroId"],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      "primaryRunes": primaryRunes?.map((e) => e.toJson()).toList(),
      "secondaryRunes": secondaryRunes?.map((e) => e.toJson()).toList(),
      "thirdRunes": thirdRunes?.map((e) => e.toJson()).toList(),
      "primaryRuneKey": primaryRuneKey,
      "secondaryRuneKey": secondaryRuneKey,
      "configName": configName,
      "heroId": heroId,
    };
  }
}
