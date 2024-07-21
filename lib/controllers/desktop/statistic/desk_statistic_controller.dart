import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:intl/intl.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_record_list_controller.dart';
import 'package:lol_master_app/entities/statistic/game_record.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/date_utils.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/statistic/statistic_widgets/correlation_statistic_grahpx.dart';
import 'package:lol_master_app/widgets/dropmenu/drop_menu.dart';

class FilterParams {
  // 显示胜相关
  bool isShowWinTop = true;

  // 日期范围
  DateRange? selectedDateRange = DateRange(
    DateTime.now().subtract(const Duration(days: 7)),
    DateTime.now(),
  );

  // 评分标准
  StatisticStandardGroup? standardGroup;

  // 选择的英雄
  List<String> heroList = [];

  // 选择的段位
  List<String> rankLevelList = [];
}

class DeskStatisticController extends MvcController {
  var groupList = <StatisticStandardGroup>[];

  List<ChildItemWinRate> winTopList = [];

  List<ChildItemWinRate> failTopList = [];

  var filterParams = FilterParams();

  var recordListController = DeskRecordListController();

  int selectGroupIndex = 0;

  var listPopupTime = 0;

  var correlationController = CorrelationStatisticGraphxController();

  var winModeController = MyDropDownMenuController(
    items: ["胜相关统计", "负相关统计"],
    selectItem: "胜相关统计",
  );

  String get currentName => selectGroupIndex < groupList.length
      ? groupList[selectGroupIndex].name ?? ""
      : "";

  StatisticStandardGroup? get currentStandardGroup =>
      selectGroupIndex < groupList.length ? groupList[selectGroupIndex] : null;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    groupList = await StatisticStandardService.instance.getStandardGroupList();
    selectGroupIndex =
        groupList.indexWhere((element) => element.selected == true);
    if (selectGroupIndex == -1) {
      selectGroupIndex = 0;
    }
    await readSelectGroupId();
    filterParams.standardGroup = currentStandardGroup;
    await calcStatisticGraphx();
    notifyListeners();
  }

  void updateSelectDateRange(DateRange? value) {
    filterParams.selectedDateRange = value;
    calcStatisticGraphx();
    recordListController.fetchData();
    notifyListeners();
  }

  void updateSelectGroup(int index) {
    selectGroupIndex = index;
    filterParams.standardGroup = currentStandardGroup;
    notifyListeners();
    saveSelectGroupId();
    calcStatisticGraphx();
  }

  Future<void> saveSelectGroupId() async {
    var group = groupList[selectGroupIndex];
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

  /// 1.统计数据要考虑选择的英雄和段位，以及日期范围
  /// 2.用户评分之后，需要刷新统计图
  Future<void> calcStatisticGraphx() async {
    var groupId = currentStandardGroup?.id;
    if (groupId == null) {
      return;
    }
    // 1.查询评分记录
    // 2.查询对应游戏的胜负状态
    // 3.计算每项的胜率、失败率，即相关性
    // 4.将排行靠前的相关性数据显示在top8统计图
    var list = await filterRecord(
        await StatisticStandardService.instance.getGameRecordList());

    var winMap = <String, bool>{};
    for (var value in list) {
      var win = await value.isWin();
      if (win) {
        winMap[value.gameId ?? ""] = win;
      }
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
        var isGameWin = winMap[record.gameId];
        childItemWinRate.initChildItem(record.value);
        if (isGameWin == true) {
          childItemWinRate.addWinCount(record.value);
        } else {
          childItemWinRate.addFailCount(record.value);
        }
      }
    }
    for (var counter in countMap.values) {
      counter.calcRate();
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
    updateGraphxData(winModeController.selectIndex);
  }

  void updateWinMode(int index) {
    updateGraphxData(index);
  }

  void updateGraphxData(int index) {
    if (index == 0) {
      correlationController.setData(winTopList, true);
    } else {
      correlationController.setData(failTopList, false);
    }
  }

  Future<List<GameRecord>> filterRecord(List<GameRecord> list) async {
    // 读取英雄信息
    for (var item in list) {
      await item.getHeroInfo();
    }
    // 1.日期筛选
    // 2.英雄筛选
    // 3.段位筛选
    var ret = list.where((element) {
      // 英雄筛选
      var heroList = filterParams.heroList;
      if (heroList.isEmpty) {
        return true;
      }
      return heroList.contains(element.heroInfo?.name);
    }).where((element) {
      // 段位筛选
      var rankLevelList = filterParams.rankLevelList;
      if (rankLevelList.isEmpty) {
        return true;
      }
      return rankLevelList
          .contains([element.rankLevel1, element.rankLevel2].join(""));
    }).where((element) {
      // 日期筛选
      var dateRange = filterParams.selectedDateRange;
      if (dateRange == null) {
        return true;
      }
      var gameTime = element.gameTime;
      if (gameTime != null) {
        try {
          var date = MyDateUtils.ymdFormat.parse(gameTime);
          return date.isBefore(dateRange.end) && date.isAfter(dateRange.start);
        } catch (e) {
          print(e);
        }
        try {
          var date = MyDateUtils.ymdhmsFormat.parse(gameTime);
          return date.isBefore(dateRange.end) && date.isAfter(dateRange.start);
        } catch (e) {
          print(e);
        }
      }
      return false;
    }).toList();
    return ret;
  }
}

class CountRate {
  int winCount = 0;
  int failCount = 0;
  double winRate = 0;
  double failRate = 0;
  String? value;

  CountRate({
    this.value,
  });

  TextSpan printWinRate([bool endLine = true]) {
    return TextSpan(children: [
      TextSpan(
        text: "$value\t",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      TextSpan(
        text: "胜场: ",
      ),
      TextSpan(
        text: "$winCount\t",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
      TextSpan(
        text: "胜率: ",
      ),
      TextSpan(
        text: "${winRate.toStringAsFixed(1)}%${endLine ? "\n" : ""}",
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    ]);
  }

  TextSpan printFailRate([bool endLine = true]) {
    return TextSpan(children: [
      TextSpan(
        text: "$value\t",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      TextSpan(
        text: "败场: ",
      ),
      TextSpan(
        text: "$failCount\t",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      TextSpan(
        text: "败率: ",
      ),
      TextSpan(
        text: "${failRate.toStringAsFixed(1)}%${endLine ? "\n" : ""}",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ]);
  }

  void addWinCount() {
    winCount++;
  }

  void addFailCount() {
    failCount++;
  }

  void calcRate() {
    var gameCount = (winCount + failCount);
    if (gameCount == 0) {
      return;
    }
    winRate = winCount * 100.0 / (winCount + failCount);
    failRate = failCount * 100.0 / (winCount + failCount);
  }
}

class ChildItemWinRate {
  String? itemName;
  Map<String, CountRate> childItemWinMap = {};
  double? _winRate;
  double? _failRate;

  void initChildItem(String? value) {
    if (value == null) {
      return;
    }
    childItemWinMap.putIfAbsent(value, () => CountRate(value: value));
  }

  void addWinCount(String? value) {
    if (value == null) {
      return;
    }
    var counter = childItemWinMap.putIfAbsent(
        value, () => CountRate(value: value))
      ..addWinCount();
    childItemWinMap[value] = counter;
  }

  void addFailCount(String? value) {
    if (value == null) {
      return;
    }
    var counter = childItemWinMap.putIfAbsent(
        value, () => CountRate(value: value))
      ..addFailCount();
    childItemWinMap[value] = counter;
  }

  // 子项最大胜率
  double get winRate {
    if (_winRate != null) {
      return _winRate!;
    }
    if (childItemWinMap.isEmpty) {
      return 0;
    }
    calcRate();
    var maxWinRate = childItemWinMap.values
        .map((e) => e.winRate)
        .reduce((value, element) => max(value, element));
    return _winRate = maxWinRate;
  }

  void calcRate() {
    _failRate = _winRate = null;
    for (var entry in childItemWinMap.entries) {
      var value = entry.value;
      value.calcRate();
    }
  }

  // 子项最大失败率
  double get failRate {
    if (_failRate != null) {
      return _failRate!;
    }
    if (childItemWinMap.isEmpty) {
      return 0;
    }
    calcRate();
    var maxRate = childItemWinMap.values
        .map((e) => e.failRate)
        .reduce((value, element) => max(value, element));
    return _failRate = maxRate;
  }

  String getMaxValueName(bool isWin) {
    return "maxName";
  }

  TextSpan getHintText(bool isWin) {
    if (childItemWinMap.isEmpty) {
      return TextSpan();
    }
    var rateList = childItemWinMap.values.toList();
    if (isWin) {
      rateList.sort((a, b) => b.winRate.compareTo(a.winRate));
      return TextSpan(children: [
        TextSpan(
            text: "$itemName\n",
            style: const TextStyle(
              color: Color(0xff00ff94),
              fontSize: 16,
              height: 1.2,
            )),
        if (rateList.length > 1)
          ...rateList
              .sublist(0, rateList.length - 1)
              .map((e) => e.printWinRate()),
        if (rateList.isNotEmpty) rateList.last.printWinRate(false),
      ]);
    } else {
      rateList.sort((a, b) => b.failRate.compareTo(a.failRate));
      return TextSpan(children: [
        TextSpan(
            text: "$itemName\n",
            style: const TextStyle(
              color: Color(0xff00ff94),
              fontSize: 16,
              height: 1.4,
            )),
        if (rateList.length > 1)
          ...rateList
              .sublist(0, rateList.length - 1)
              .map((e) => e.printFailRate()),
        if (rateList.isNotEmpty) rateList.last.printFailRate(false),
      ]);
    }
  }
}
