import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/entities/statistic/game_record.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/table/table_filter_widget.dart';
import 'package:lol_master_app/widgets/table/table_widget.dart';

enum ColumnType {
  text,
  number,
  select,
  // 英雄
  hero,
  // 符文
  rune,
  // 召唤师技能
  spell,
  rankLevel,
  kda,
  score,
  remark,
  detail,
  gameResult;

  static ColumnType fromName(String name) {
    return ColumnType.values.where((element) => element.name == name).first;
  }
}

final gameHeaders = <MyHeaderItem>[
  MyHeaderItem(
    key: "id",
    name: "序号",
    preferWidth: 30,
    columnType: ColumnType.number.name,
  ),
  MyHeaderItem(
    key: "gameTime",
    name: "开始时间",
    preferWidth: 100,
    columnType: ColumnType.text.name,
  ),
  // items: HeroInfo?
  MyHeaderItem(
    key: "hero",
    name: "使用英雄",
    preferWidth: 110,
    columnType: ColumnType.hero.name,
  ),
  MyHeaderItem(
    key: "gameResult",
    name: "结果",
    preferWidth: 110,
    columnType: ColumnType.gameResult.name,
  ),
  // items: String=>rankLevel1+rankLevel2
  MyHeaderItem(
    key: "rankLevel",
    name: "段位",
    preferWidth: 100,
    columnType: ColumnType.rankLevel.name,
  ),
  MyHeaderItem(
    key: "kda",
    name: "KDA",
    preferWidth: 100,
    columnType: ColumnType.kda.name,
  ),
  MyHeaderItem(
    key: "score",
    name: "自我评分",
    preferWidth: 100,
    columnType: ColumnType.score.name,
  ),
  MyHeaderItem(
    key: "remark",
    name: "备注",
    preferWidth: 160,
    columnType: ColumnType.remark.name,
    editable: true,
    flex: 1,
  ),
  MyHeaderItem(
    key: "gameDetail",
    name: "更多",
    preferWidth: 100,
    columnType: ColumnType.detail.name,
  ),
];

class DeskRecordListController extends MvcController {
  List<GameRecord> records = [];
  var tableController = MyTableController();
  var filterControllerMap = {
    "hero": TableFilterController(
      columnKey: "hero",
      filterSearch: (value, text) => value?.name?.contains(text) == true,
      filterEquals: (a, b) => a.name == b.name,
      items: [],
    ),
    "rankLevel": TableFilterController(
      columnKey: "rankLevel",
      filterSearch: (value, text) => value?.contains(text) == true,
      filterEquals: (a, b) => a.join("") == b,
      items: [],
    ),
  };

  // 当前评分标准: 如果为空，则渲染游戏数据
  StatisticStandardGroup? group;
  DeskStatisticController? statisticController;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    statisticController = MvcController.of<DeskStatisticController>(context);
    fetchData();
  }

  Future<void> fetchData() async {
    records = await StatisticStandardService.instance.getGameRecordList();
    await fetchGameData();
    notifyListeners();
  }

  /// 查询游戏数据
  /// 1.表头：序号，使用英雄(下拉筛选)，段位，开始时间，对局耗时，召唤师技能，符文，kda，
  ///   输出占比，承伤占比，推塔数量，补刀数量，备注
  /// 2.将record转换为内容数据rows
  Future<void> fetchGameData() async {
    var records = this.records;
    var dateRange = statisticController?.filterParams.selectedDateRange;
    if (dateRange != null) {
      records = records.where((element) {
        var gameTime = element.gameTime;
        if (gameTime != null && gameTime.length == "yyyy-MM-dd".length) {
          var date = DateFormat("yyyy-MM-dd").parse(gameTime);
          return date.isBefore(dateRange.end) && date.isAfter(dateRange.start);
        }
        return false;
      }).toList();
    }
    var headers = gameHeaders
        .map((e) => e.copyWith(
              filters: [],
              selectFilters: [],
              items: [],
            ))
        .toList();
    for (var i = 0; i < headers.length; i++) {
      headers[i].columnIndex = i;
    }

    var rows = <MyRowItem>[];
    for (var i = 0; i < records.length; i++) {
      var record = records[i];
      var row = MyRowItem(value: record);
      var colIndex = 0;
      row.cells = [
        MyCellItem(value: i + 1, rowIndex: i, colIndex: colIndex++),
        MyCellItem(value: record.gameTime, rowIndex: i, colIndex: colIndex++),
        MyCellItem(
            value: await record.getHeroInfo(),
            rowIndex: i,
            colIndex: colIndex++),
        MyCellItem(
            value: (await record.isWin()) ? "胜利" : "失败",
            rowIndex: i,
            colIndex: colIndex++),
        MyCellItem(
            value: [record.rankLevel1, record.rankLevel2],
            rowIndex: i,
            colIndex: colIndex++),
        MyCellItem(
            value: [record.kills, record.deaths, record.assists],
            rowIndex: i,
            colIndex: colIndex++),
        MyCellItem(value: "评分", rowIndex: i, colIndex: colIndex++),
        MyCellItem(value: "备注", rowIndex: i, colIndex: colIndex++),
        MyCellItem(value: "详细数据", rowIndex: i, colIndex: colIndex++),
      ];
      rows.add(row);
    }
    var filterList = filterControllerMap.values.toList();
    // 过滤并且排序数据
    List<MyRowItem> resultList = getFilterResultList(filterList, rows);
    tableController.setData(headers, resultList);
    initHeroFilters(filterControllerMap["hero"]!, rows);
    initRankLevelFilters(filterControllerMap["rankLevel"]!, rows);
  }

  List<MyRowItem> getFilterResultList(
      List<TableFilterController> filterList, List<MyRowItem> rows) {
    filterList.sort((a, b) {
      return a.orderUpdateTime.compareTo(b.orderUpdateTime);
    });
    List<dynamic> filterFunctions = getFilterFunctions(filterList);
    List<dynamic> compareFunctions = getCompareFunctions(filterList);
    List<MyRowItem> resultList = tableController.getFilterResult(
        rows, filterFunctions, compareFunctions);
    if (resultList.length > 100) {
      resultList = resultList.sublist(0, 100);
    }
    for (var i = 0; i < resultList.length; i++) {
      var item = resultList[i];
      item.cells[0].value = i + 1;
    }
    return resultList;
  }

  List<dynamic> getFilterFunctions(
      List<TableFilterController<dynamic>> filterList) {
    return tableController.getFilterFunctions(filterList);
  }

  List<dynamic> getCompareFunctions(
      List<TableFilterController<dynamic>> filterList) {
    var compareFunctions = tableController.getCompareFunctions(filterList);
    compareFunctions.add((a, b) {
      var aTime = a.cells[1].value ?? "";
      var bTime = b.cells[1].value ?? "";
      return bTime.compareTo(aTime);
    });
    return compareFunctions;
  }

  void initHeroFilters(
      TableFilterController heroFilterController, List<MyRowItem> rows) {
    var headerItem =
        tableController.headers.where((element) => element.key == "hero").first;
    var heroList = rows
        .map((e) => e.cells[headerItem.columnIndex].value as HeroInfo?)
        .toSet();
    headerItem.filters = heroList.toList();
    headerItem.init();
    heroFilterController.items = headerItem.filters;
    heroFilterController.filterItems = headerItem.filters;
  }

  void initRankLevelFilters(
      TableFilterController rankLevelFilterController, List<MyRowItem> rows) {
    var headerItem = tableController.headers
        .where((element) => element.key == "rankLevel")
        .first;
    var levelList =
        rows.map((e) => e.cells[headerItem.columnIndex].value.join("")).toSet();
    headerItem.filters = levelList.toList();
    headerItem.init();
    rankLevelFilterController.items = headerItem.filters;
    rankLevelFilterController.filterItems = headerItem.filters;
  }

  // 列表数据改变要通知统计图更新
  Future<void> refreshTable() async {
    // 将筛选条件保存到统计图控制器
    var filterParams = statisticController?.filterParams;
    var selectRankLevel = filterControllerMap["rankLevel"]!.selectItems;
    var selectedHero = filterControllerMap["hero"]!.selectItems;
    filterParams?.rankLevelList = selectRankLevel.isEmpty
        ? []
        : selectRankLevel.map((e) => e?.toString() ?? "").toList();
    filterParams?.heroList = selectedHero.isEmpty
        ? []
        : selectedHero.map((e) => e.name?.toString() ?? "").toList();
    // 更新统计数据
    statisticController?.calcStatisticGraphx();
    await fetchData();
  }

  bool hasFilter(MyHeaderItem header) {
    return filterControllerMap.containsKey(header.key);
  }

  String? getGameId(MyCellItem cell) {
    return tableController.rows[cell.rowIndex].value.gameId;
  }

  int? getStandardGroupId(BuildContext context) {
    var controller = MvcController.of<DeskStatisticController>(context);
    return controller.currentStandardGroup?.id;
  }
}
