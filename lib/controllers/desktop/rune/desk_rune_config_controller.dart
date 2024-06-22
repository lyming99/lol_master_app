import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lol_master_app/services/rune/rune_service_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

import '../../../entities/rune/rune.dart';

List<List<RuneConfigItem>> getThirdRunes() {
  var path = "assets/lol/img/rune/StatMods";
  return [
    [
      RuneConfigItem(
        key: "5008",
        name: "适应之力",
        icon: "$path/StatModsAdaptiveForceIcon.png",
        desc: "+9适应之力",
      ),
      RuneConfigItem(
        key: "5005",
        name: "攻击速度",
        icon: "$path/StatModsAttackSpeedIcon.png",
        desc: "+10%攻击速度",
      ),
      RuneConfigItem(
        key: "5007",
        name: "技能急速",
        icon: "$path/StatModsCDRScalingIcon.png",
        desc: "+8技能急速",
      ),
    ],
    [
      RuneConfigItem(
        key: "5008",
        name: "适应之力",
        icon: "$path/StatModsAdaptiveForceIcon.png",
        desc: "+9适应之力",
      ),
      RuneConfigItem(
        key: "5010",
        name: "移动速度",
        icon: "$path/StatModsMovementSpeedIcon.png",
        desc: "+2%移动速度",
      ),
      RuneConfigItem(
        key: "5001",
        name: "成长生命值",
        icon: "$path/StatModsHealthPlusIcon.png",
        desc: "+10-180生命值(基于等级)",
      ),
    ],
    [
      RuneConfigItem(
        key: "5011",
        name: "生命值",
        icon: "$path/StatModsHealthScalingIcon.png",
        desc: "+65生命值",
      ),
      RuneConfigItem(
        key: "5013",
        name: "韧性和减速抗性",
        icon: "$path/StatModsTenacityIcon.png",
        desc: "+10%韧性和减速抗性",
      ),
      RuneConfigItem(
        key: "5001",
        name: "成长生命值",
        icon: "$path/StatModsHealthPlusIcon.png",
        desc: "+10-180生命值(基于等级)",
      ),
    ],
  ];
}

class DeskRuneConfigController extends MvcController {
  RuneConfig config;

  /// 主系符文分组列表
  var primaryRuneGroupList = <RuneGroupItem>[];

  /// 副系符文分组列表
  var secondaryRuneGroupList = <RuneGroupItem>[];

  /// 选择的主系符文组
  RuneGroupItem? primarySelectRuneGroup;

  /// 选择的副系符文组
  RuneGroupItem? secondarySelectRuneGroup;

  var configNameController = TextEditingController();

  /// 主系符文
  List<List<RuneConfigItem>> get primaryRunes =>
      primarySelectRuneGroup?.runes ?? [];

  /// 副系符文
  List<List<RuneConfigItem>> get secondaryRunes =>
      secondarySelectRuneGroup?.runes ?? [];

  /// 第三系符文：生命值、适应之力之类的
  List<List<RuneConfigItem>> thirdRunes = [];

  var renameEditable = false;
  var saveEnable = false;

  DeskRuneConfigController({
    required this.config,
  });

  String get selectPrimaryRuneKey =>
      primarySelectRuneGroup?.key ?? "Domination";

  bool get isPrimarySelectAll => getSelectRunes(primaryRunes).length == 4;

  get configName => config.configName == "" || config.configName == null
      ? "未命名符文"
      : config.configName;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<Map> getRuneDescMap() async {
    var runeJson =
    await rootBundle.loadString("assets/lol/data/rune_list.json");
    var jsonArr = jsonDecode(runeJson);
    return jsonArr["rune"] as Map;
  }

  Future<void> fetchData() async {
    thirdRunes = getThirdRunes();
    var runeJson =
        await rootBundle.loadString("assets/lol/data/runesReforged.json");
    var jsonArr = jsonDecode(runeJson);
    primaryRuneGroupList.clear();
    secondaryRuneGroupList.clear();
    var runeDescMap = await getRuneDescMap();
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
            key: rune['id']?.toString(),
            name: rune["name"],
            icon: "assets/lol/${rune["icon"]}",
            desc: dealWithDesc(runeDescMap[rune['id']?.toString()]['longdesc']),
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
    initRuneSettings();
    configNameController.text =
        config.configName == null || config.configName == ""
            ? "未命名符文"
            : config.configName!;
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
  void initRuneSettings() {
    // 1.加载分组配置
    primarySelectRuneGroup?.selected = false;
    secondarySelectRuneGroup?.selected = false;
    primarySelectRuneGroup = primaryRuneGroupList.where((element) {
          return element.key == config.primaryRuneKey;
        }).firstOrNull ??
        primaryRuneGroupList.first;
    secondarySelectRuneGroup = secondaryRuneGroupList.where((element) {
          return element.key == config.secondaryRuneKey;
        }).firstOrNull ??
        secondaryRuneGroupList.first;
    primarySelectRuneGroup?.selected = true;
    secondarySelectRuneGroup?.selected = true;
    // 2.加载主系符文选项
    for (var item in config.primaryRunes ?? []) {
      primarySelectRuneGroup?.runes.forEach((element) {
        element.forEach((rune) {
          if (rune.key == item.key) {
            rune.selected = true;
          }
        });
      });
    }
    // 3.加载副系符文选项
    for (var item in config.secondaryRunes ?? []) {
      secondarySelectRuneGroup?.runes.forEach((element) {
        element.forEach((rune) {
          if (rune.key == item.key) {
            rune.selected = true;
          }
        });
      });
    }
    // 4.加载属性符文选项
    int index = 0;
    for (var item in config.thirdRunes ?? []) {
      for (var rune in thirdRunes[index]) {
        if (rune.key == item.key) {
          rune.selected = true;
        }
      }
      index++;
    }
  }

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
    saveEnable = true;
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
    saveEnable = true;
    notifyListeners();
  }

  /// 选择主系符文
  void selectPrimaryRune(int row, int col) {
    saveEnable = true;
    clearRunesSelectState(primaryRunes[row]);
    primaryRunes[row][col].selected = true;
    notifyListeners();
  }

  /// 选择副系符文
  /// 1.清除当前行符文的状态
  /// 2.选择当前符文
  /// 3.9选2规则，如果选择了3个符文，则清除较新选择的符文
  void selectSecondaryRune(int row, int col) {
    saveEnable = true;
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
    saveEnable = true;
    clearRunesSelectState(thirdRunes[row]);
    thirdRunes[row][col].selected = true;
    notifyListeners();
  }

  Future<void> saveConfig() async {
    //1.保存名称
    config.configName = configNameController.text;
    //2.保存符文系列
    config.primaryRuneKey = primarySelectRuneGroup?.key;
    config.secondaryRuneKey = secondarySelectRuneGroup?.key;
    //3.保存主系符文
    config.primaryRunes = getSelectRunes(primaryRunes);
    //4.保存副系符文
    config.secondaryRunes = getSelectRunes(secondaryRunes);
    //5.保存属性符文
    config.thirdRunes = getSelectRunes(thirdRunes);
    var runeService = RuneServiceImpl();
    await runeService.updateRuneConfig(config);
    saveEnable = false;
    notifyListeners();
  }

  void showRenameEdit() {
    renameEditable = true;
    configNameController.text = config.configName ?? "未命名符文";
    notifyListeners();
  }

  void hideRenameEdit() {
    renameEditable = false;
    notifyListeners();
  }

  void setSaveEnable(bool value) {
    saveEnable = value;
    notifyListeners();
  }

  Future<void> deleteConfig() async {
    var runeService = RuneServiceImpl();
    await runeService.deleteRuneConfig(config);
  }

  String dealWithDesc(String src) {
    return src.replaceAll("<br>", "\n").replaceAll("<br/>", "\n").replaceAll(RegExp("<[^>]*>"), "");
  }
}
