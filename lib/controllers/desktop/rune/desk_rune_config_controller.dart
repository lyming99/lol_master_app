import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lol_master_app/util/mvc.dart';

List<List<RuneConfigItem>> getThirdRunes() {
  var path = "assets/lol/img/rune/StatMods";
  return [
    [
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsAdaptiveForceIcon.png",
      ),
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsAttackSpeedIcon.png",
      ),
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsCDRScalingIcon.png",
      ),
    ],
    [
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsAdaptiveForceIcon.png",
      ),
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsMovementSpeedIcon.png",
      ),
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsHealthPlusIcon.png",
      ),
    ],
    [
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsHealthScalingIcon.png",
      ),
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsTenacityIcon.png",
      ),
      RuneConfigItem(
        name: "",
        icon: "$path/StatModsHealthPlusIcon.png",
      ),
    ],
  ];
}

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
  String? name;
  String? desc;
  String? icon;
  bool? selected;
  int selectTime = 0;

  RuneConfigItem({
    this.name,
    this.desc,
    this.icon,
    this.selected,
  });

  // copy
  RuneConfigItem copy() {
    return RuneConfigItem(
      name: name,
      desc: desc,
      icon: icon,
    );
  }

  factory RuneConfigItem.fromJson(Map<String, dynamic> json) {
    return RuneConfigItem(
      name: json["name"],
      desc: json["desc"],
      icon: json["icon"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "desc": desc,
      "icon": icon,
    };
  }
}

class RuneConfigs {
  String? configName;
  String? primaryRuneKey;
  String? secondaryRuneKey;
  List<RuneConfigItem>? primaryRunes;
  List<RuneConfigItem>? secondaryRunes;
  List<RuneConfigItem>? thirdRunes;

  RuneConfigs({
    this.configName,
    this.primaryRuneKey,
    this.secondaryRuneKey,
    this.primaryRunes,
    this.secondaryRunes,
    this.thirdRunes,
  });

  // from json
  factory RuneConfigs.fromJson(Map<String, dynamic> json) {
    return RuneConfigs(
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
    };
  }
}

class DeskRuneConfigController extends MvcController {
  RuneConfigs config;

  /// 主系符文分组列表
  var primaryRuneGroupList = <RuneGroupItem>[];

  /// 副系符文分组列表
  var secondaryRuneGroupList = <RuneGroupItem>[];

  /// 选择的主系符文组
  RuneGroupItem? primarySelectRuneGroup;

  /// 选择的副系符文组
  RuneGroupItem? secondarySelectRuneGroup;

  /// 主系符文
  List<List<RuneConfigItem>> get primaryRunes =>
      primarySelectRuneGroup?.runes ?? [];

  /// 副系符文
  List<List<RuneConfigItem>> get secondaryRunes =>
      secondarySelectRuneGroup?.runes ?? [];

  /// 第三系符文：生命值、适应之力之类的
  List<List<RuneConfigItem>> thirdRunes = [];

  DeskRuneConfigController({
    required this.config,
  });

  String get selectPrimaryRuneKey => primarySelectRuneGroup?.key ?? "";

  bool get isPrimarySelectAll => getSelectRunes(primaryRunes).length == 4;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    thirdRunes = getThirdRunes();
    var runeJson =
        await rootBundle.loadString("assets/lol/data/runesReforged.json");
    var jsonArr = jsonDecode(runeJson);
    primaryRuneGroupList.clear();
    secondaryRuneGroupList.clear();
    for (var group in jsonArr as List) {
      var groupItem = RuneGroupItem(
        key: group["key"],
        name: group["name"],
        icon: "assets/lol/${group["icon"]}",
        bgIcon: "assets/lol/${group["bgIcon"]}",
        itemIcon: "assets/lol/${group["itemIcon"]}",
        selected: false,
      );
      primaryRuneGroupList.add(groupItem);
      var slots = group["slots"] as List;
      for (var slot in slots) {
        var runes = slot["runes"] as List;
        var runeList = <RuneConfigItem>[];
        for (var rune in runes) {
          var runeItem = RuneConfigItem(
            name: rune["name"],
            icon: "assets/lol/${rune["icon"]}",
            desc: rune["longDesc"],
            selected: false,
          );
          runeList.add(runeItem);
        }
        groupItem.runes.add(runeList);
      }
    }
    secondaryRuneGroupList = primaryRuneGroupList.map((e) => e.copy()).toList();
    secondaryRuneGroupList.removeAt(0);
    primarySelectRuneGroup = primaryRuneGroupList[0]..selected = true;
    secondarySelectRuneGroup = secondaryRuneGroupList[0]..selected = true;
    notifyListeners();
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, covariant DeskRuneConfigController oldController) {
    super.onDidUpdateWidget(context, oldController);
    primaryRuneGroupList = oldController.primaryRuneGroupList;
    secondaryRuneGroupList = oldController.secondaryRuneGroupList;
    primarySelectRuneGroup = oldController.primarySelectRuneGroup;
    secondarySelectRuneGroup = oldController.secondarySelectRuneGroup;
    thirdRunes = oldController.thirdRunes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;

  /// 加载配置
  void initRuneSettings() {}

  /// 选择主系符文组
  /// 1.如果当前主系符文组被选中，则取消选择动作
  /// 2.切换到选择的符文组，清除已经选择的符文项
  /// 3.判断副系符文组是否被主系选中，如果被选中，则切换一个副系符文组
  void selectPrimaryRuneGroup(int index) {
    // 1
    if (primarySelectRuneGroup?.name == primaryRuneGroupList[index].name) {
      return;
    }
    // 2
    primarySelectRuneGroup = primaryRuneGroupList[index];
    for (var i = 0; i < primaryRuneGroupList.length; i++) {
      primaryRuneGroupList[i].selected = i == index;
    }
    clearRunesGroupSelectState(primarySelectRuneGroup?.runes);
    //3
    if (primarySelectRuneGroup?.name == secondarySelectRuneGroup?.name) {
      secondaryRuneGroupList = primaryRuneGroupList
          .where((element) => element.name != primarySelectRuneGroup?.name)
          .map((e) => e.copy())
          .toList();
      secondarySelectRuneGroup = secondaryRuneGroupList[0];
      secondarySelectRuneGroup?.selected = true;
      clearRunesGroupSelectState(secondarySelectRuneGroup?.runes);
    } else {
      var secondaryRuneGroupList = primaryRuneGroupList
          .where((element) => element.name != primarySelectRuneGroup?.name)
          .map((e) => e.copy())
          .toList();
      for (int i = 0; i < secondaryRuneGroupList.length; i++) {
        if (secondaryRuneGroupList[i].name == secondarySelectRuneGroup?.name) {
          secondaryRuneGroupList[i] = secondarySelectRuneGroup!;
        }
      }
      this.secondaryRuneGroupList = secondaryRuneGroupList;
    }
    notifyListeners();
  }

  void clearRunesGroupSelectState(List<List<RuneConfigItem>>? runes) {
    if (runes == null) {
      return;
    }
    for (var i = 0; i < runes.length; i++) {
      for (var j = 0; j < runes[i].length; j++) {
        runes[i][j].selected = false;
      }
    }
  }

  /// 选择副系符文组
  /// 1.如果当前主系符文组被选中，则取消选择动作
  /// 2.切换到选择的符文组，清除已经选择的符文项
  void selectSecondaryRuneGroup(int index) {
    // 1
    if (secondarySelectRuneGroup?.name == secondaryRuneGroupList[index].name) {
      return;
    }
    // 2
    secondarySelectRuneGroup = secondaryRuneGroupList[index];
    for (var i = 0; i < secondaryRuneGroupList.length; i++) {
      secondaryRuneGroupList[i].selected = i == index;
    }
    clearRunesGroupSelectState(secondarySelectRuneGroup?.runes);
    notifyListeners();
  }

  /// 选择主系符文
  void selectPrimaryRune(int row, int col) {
    clearRunesSelectState(primaryRunes[row]);
    primaryRunes[row][col].selected = true;
    notifyListeners();
  }

  /// 选择副系符文
  /// 1.清除当前行符文的状态
  /// 2.选择当前符文
  /// 3.9选2规则，如果选择了3个符文，则清除较新选择的符文
  void selectSecondaryRune(int row, int col) {
    clearRunesSelectState(secondaryRunes[row]);
    secondaryRunes[row][col].selected = true;
    secondaryRunes[row][col].selectTime = DateTime.now().millisecondsSinceEpoch;
    List<RuneConfigItem> selectItems = getSelectRunes(secondaryRunes);
    if (selectItems.length > 2) {
      selectItems.sort((a, b) {
        return b.selectTime.compareTo(a.selectTime);
      });
      while (selectItems.length > 2) {
        selectItems.removeLast().selected = false;
      }
    }
    notifyListeners();
  }

  /// 获取选择的符文
  List<RuneConfigItem> getSelectRunes(List<List<RuneConfigItem>> runes) {
    List<RuneConfigItem> selectItems = [];
    for (var runes in runes) {
      for (var value in runes) {
        if (value.selected == true) {
          selectItems.add(value);
        }
      }
    }
    return selectItems;
  }

  /// 清除符文选择状态
  void clearRunesSelectState(List<RuneConfigItem>? runes) {
    if (runes == null) {
      return;
    }
    for (var value in runes) {
      value.selected = false;
    }
  }

  void selectThirdRune(int row, int col) {
    clearRunesSelectState(thirdRunes[row]);
    thirdRunes[row][col].selected = true;
    notifyListeners();
  }
}
