import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_record_list_controller.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskStatisticController extends MvcController {
  var groupList = <StatisticStandardGroup>[];
  List<ChildItemWinRate> winTopList = [];
  List<ChildItemWinRate> failTopList = [];
  bool isShowWinTop = true;

  DateRange? selectedDateRange;

  DateRange? selectedRange;

  var recordListController = DeskRecordListController();

  int selectIndex = 0;

  var listPopupTime = 0;

  String get currentName =>
      selectIndex < groupList.length ? groupList[selectIndex].name ?? "" : "";

  StatisticStandardGroup? get currentStandardGroup =>
      selectIndex < groupList.length ? groupList[selectIndex] : null;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    groupList = await StatisticStandardService.instance.getStandardGroupList();
    selectIndex = groupList.indexWhere((element) => element.selected == true);
    if (selectIndex == -1) {
      selectIndex = 0;
    }
    await readSelectGroupId();
    await calcCorrelationStatisticGraphx();
    notifyListeners();
  }

  void updateSelectDateRange(DateRange? value) {
    selectedRange = value;
    notifyListeners();
  }

  void updateSelectGroup(int index) {
    selectIndex = index;
    notifyListeners();
    saveSelectGroupId();
  }

  Future<void> saveSelectGroupId() async {
    var group = groupList[selectIndex];
    var config = await LolConfigService.instance.getCurrentConfig();
    config?.currentStandardGroupId = group.id;
    await LolConfigService.instance.updateCurrentConfig(config);
  }

  Future<void> readSelectGroupId() async {
    var config = await LolConfigService.instance.getCurrentConfig();
    var currentId = config?.currentStandardGroupId;
    var index = groupList.indexWhere((element) => element.id == currentId);
    if (index != -1) {
      updateSelectGroup(index);
    }
  }

  Future<void> calcCorrelationStatisticGraphx() async {
    var groupId = currentStandardGroup?.id;
    if (groupId == null) {
      return;
    }
    // 1.查询评分记录
    // 2.查询对应游戏的胜负状态
    // 3.计算每项的胜率、失败率，即相关性
    // 4.将排行靠前的相关性数据显示在top8统计图
    var list = await StatisticStandardService.instance.getGameRecordList();
    var winMap = <String, bool>{};
    for (var value in list) {
      var win = await value.isWin();
      winMap[value.gameId ?? ""] = win;
    }
    var countMap = <String, ChildItemWinRate>{};
    var itemList =
        await StatisticStandardService.instance.getStandardItemList(groupId);
    for (var item in itemList) {
      var itemId = item.id;
      if (itemId == null) {
        continue;
      }
      var recordList = await StatisticStandardService.instance
          .getStandardRecordList(itemId.toString());
      for (var record in recordList) {
        var itemName = item.name;
        if (itemName == null) {
          continue;
        }
        var childItemWinRate = countMap.putIfAbsent(
            itemName, () => ChildItemWinRate()..itemName = itemName);
        childItemWinRate.addGameCount();
        var isGameWin = winMap[record.gameId];
        childItemWinRate.initChildItem(record.value);
        if (isGameWin == true) {
          childItemWinRate.addWinCount(record.value);
        }
      }
    }
    // 将countMap 计算，得到统计图数据
    var winTopList = countMap.values.toList();
    winTopList.sort((a, b) {
      return b.winRate.compareTo(a.winRate);
    });
    var failTopList = countMap.values.toList();
    failTopList.sort((a, b) {
      return b.failRate.compareTo(a.failRate);
    });
    this.winTopList = winTopList;
    this.failTopList = failTopList;
  }
}

class ChildItemWinRate {
  String? itemName;
  int gameCount = 0;
  Map<String, int> childItemWinMap = {};
  double? _winRate;
  double? _failRate;

  void addGameCount() {
    gameCount++;
  }

  void initChildItem(String? value) {
    if (value == null) {
      return;
    }
    childItemWinMap.putIfAbsent(value, () => 0);
  }

  void addWinCount(String? value) {
    if (value == null) {
      return;
    }
    var count = childItemWinMap.putIfAbsent(value, () => 0) + 1;
    childItemWinMap[value] = count;
  }

  // 子项最大胜率
  double get winRate {
    if (_winRate != null) {
      return _winRate!;
    }
    if (gameCount == 0) {
      return 0;
    }
    if (childItemWinMap.isEmpty) {
      return 0;
    }
    var maxCount =
        childItemWinMap.values.reduce((value, element) => max(value, element));
    return _winRate = maxCount * 1.0 / gameCount;
  }

  // 子项最大失败率
  double get failRate {
    if (_failRate != null) {
      return _failRate!;
    }
    if (gameCount == 0) {
      return 0;
    }
    if (childItemWinMap.isEmpty) {
      return 0;
    }
    var minCount =
        childItemWinMap.values.reduce((value, element) => min(value, element));
    return _failRate = (gameCount - minCount) * 1.0 / gameCount;
  }

  String getMaxValueName(bool isWin) {
    return "maxName";
  }

  String getHintText(bool isWin) {
    if (childItemWinMap.isEmpty) {
      return "";
    }
    if (isWin) {
      var key = childItemWinMap.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      return "$key \n胜率: ${winRate.toStringAsFixed(2)}";
    } else {
      var key = childItemWinMap.entries
          .reduce((a, b) => a.value < b.value ? a : b)
          .key;
      return "$key \n失败率: ${failRate.toStringAsFixed(2)}";
    }
  }
}
