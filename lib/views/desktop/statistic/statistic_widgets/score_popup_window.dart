import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/circle_button.dart';
import 'package:lol_master_app/widgets/dropmenu/drop_menu.dart';
import 'package:lol_master_app/widgets/popup_window.dart';
import 'package:lol_master_app/widgets/table/table_widget.dart';

class ScoreItem {
  StatisticStandardItem item;
  StatisticStandardRecord record;

  ScoreItem({
    required this.item,
    required this.record,
  });

  List get itemArray {
    var itemJson = jsonDecode(item.items ?? "[]");
    return itemJson.map((e) => e.toString()).toList();
  }
}

class ScorePopupController extends MvcController {
  String? gameId;
  int? standardId;
  var tableController = MyTableController();

  var listPopupTime = 0;

  var groupList = <StatisticStandardGroup>[];
  var selectGroupIndex = 0;

  ScorePopupController({
    this.gameId,
    this.standardId,
  });

  bool get hasStandardGroup => selectGroupIndex < groupList.length;

  String get currentGroupName =>
      hasStandardGroup ? (groupList[selectGroupIndex].name ?? "") : "";

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchStandardGroupList();
    fillTable();
    notifyListeners();
  }

  Future<void> fillTable() async {
    if (!hasStandardGroup) {
      tableController.setData([], []);
      return;
    }
    var selectGroup = groupList[selectGroupIndex];
    var records = await StatisticStandardService.instance
        .getStandardRecordListByGameId(gameId?.toString() ?? "");
    var recordMap = <String, StatisticStandardRecord>{};
    for (var item in records) {
      recordMap[item.standardItemId?.toString() ?? ""] = item;
    }
    var standardItems = selectGroup.items;
    List<ScoreItem> scoreItems = [];
    for (var standardItem in standardItems) {
      var oldItem = recordMap[standardItem.id.toString()];
      if (oldItem != null) {
        scoreItems.add(ScoreItem(item: standardItem, record: oldItem));
      } else {
        scoreItems.add(ScoreItem(
            item: standardItem,
            record: StatisticStandardRecord(
              standardItemId: standardItem.id,
              gameId: gameId,
            )));
      }
    }
    var rows = <MyRowItem>[];
    for (var i = 0; i < scoreItems.length; i++) {
      var scoreItem = scoreItems[i];
      var row = MyRowItem(
        cells: [
          // 序号
          MyCellItem(value: i + 1, rowIndex: i, colIndex: 0),
          // 评分项目
          MyCellItem(value: scoreItem, rowIndex: i, colIndex: 1),
          // 评分描述
          MyCellItem(value: scoreItem, rowIndex: i, colIndex: 2),
          // 评分
          MyCellItem(value: scoreItem, rowIndex: i, colIndex: 3),
        ],
      );
      rows.add(row);
    }
    var headers = [
      MyHeaderItem(
        key: "id",
        name: "序号",
        preferWidth: 30,
      ),
      MyHeaderItem(
        key: "itemName",
        name: "评分项目",
        preferWidth: 100,
        flex: 1,
      ),
      MyHeaderItem(
        key: "itemDesc",
        name: "评分描述",
        preferWidth: 100,
        flex: 5,
      ),
      MyHeaderItem(
        key: "score",
        name: "评分",
        preferWidth: 120,
        flex: 1,
      ),
    ];
    tableController.setData(headers, rows);
  }

  Future<void> fetchStandardGroupList() async {
    groupList =
        await StatisticStandardService.instance.getStandardGroupList(true);
    selectGroupIndex =
        max(0, groupList.indexWhere((element) => element.id == standardId));
  }

  void updateSelectGroup(int index) {
    selectGroupIndex = index;
    fillTable();
    notifyListeners();
  }

  void saveRecord(ScoreItem scoreItem) async {
    await StatisticStandardService.instance
        .upsertStandardRecord(scoreItem.record);
  }
}

class ScorePopupWindow extends MvcView<ScorePopupController> {
  const ScorePopupWindow({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 180,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xfff6dba6)),
                  ),
                  child: Builder(builder: (context) {
                    return CircleButton(
                      onTap: () {
                        showStandardItemListViewPopup(context);
                      },
                      radius: 0,
                      child: SizedBox(
                        width: 160,
                        height: 30,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text(controller.currentGroupName)),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: MyTableWidget(
                controller: controller.tableController,
                headerBuilder: (context, index) {
                  return SizedBox(
                    width: controller.tableController.headers[index].width,
                    child: Center(
                      child:
                          Text(controller.tableController.headers[index].name),
                    ),
                  );
                },
                cellBuilder: (context, rowIndex, colIndex) {
                  var cellWidth =
                      controller.tableController.headers[colIndex].width;
                  var cellItem =
                      controller.tableController.rows[rowIndex].cells[colIndex];
                  Widget? child;
                  if (colIndex == 0) {
                    child = Text(cellItem.value?.toString() ?? "");
                  } else {
                    var value = cellItem.value as ScoreItem;
                    if (colIndex == 1) {
                      // 评分项目
                      child = Text(value.item.name ?? "");
                    }
                    if (colIndex == 2) {
                      child = Tooltip(
                        message: value.item.description ?? "",
                        child: Text(
                          value.item.description ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }
                    if (colIndex == 3) {
                      child = buildScoreItemWidget(value, child);
                    }
                  }
                  return SizedBox(
                    width: cellWidth,
                    child: Center(
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? buildScoreItemWidget(ScoreItem scoreItem, Widget? child) {
    var itemType = scoreItem.item.itemType;
    if (itemType == 1) {
      // 数值输入框
      child = _NumberItem(
        value: scoreItem.record.value,
        onChanged: (value) {
          scoreItem.record.value = value;
          controller.saveRecord(scoreItem);
        },
      );
    } else if (itemType == 2) {
      // switch
      child = _SwitchItem(
        value: scoreItem.record.value == "1",
        onChanged: (value) {
          scoreItem.record.value = value == true ? "1" : "0";
          controller.saveRecord(scoreItem);
        },
      );
    } else {
      // 下拉框
      var items = scoreItem.itemArray;
      child = LayoutBuilder(builder: (context, cons) {
        return MyDropDownMenu(
          width: cons.maxWidth - 16,
          controller: MyDropDownMenuController(
            items: items,
            selectItem: scoreItem.record.value,
          ),
          itemBuilder: (context, index) {
            return Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: Text("${items[index]}"),
            );
          },
          onItemSelected: (index) {
            scoreItem.record.value = items[index];
            controller.saveRecord(scoreItem);
          },
        );
      });
    }
    return child;
  }

  void showStandardItemListViewPopup(BuildContext context) {
    if (controller.listPopupTime + 200 <
        DateTime.now().millisecondsSinceEpoch) {
      showCustomDropMenu(
        context: context,
        modal: false,
        width: 252,
        height: 252,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 23, 29),
              border: Border.all(
                color: const Color(0xfff6dba6),
              ),
            ),
            child: Material(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var item = controller.groupList[index];
                  return InkWell(
                    onTap: () {
                      closePopupWindow(context);
                      controller.updateSelectGroup(index);
                    },
                    child: ListTile(
                      title: Text(item.name ?? "未命名标准"),
                    ),
                  );
                },
                itemCount: controller.groupList.length,
              ),
            ),
          );
        },
      ).then((value) =>
          controller.listPopupTime = DateTime.now().millisecondsSinceEpoch);
    }
  }
}

class _NumberItem extends StatelessWidget {
  final String? value;
  final Function(String?)? onChanged;

  const _NumberItem({
    Key? key,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: value),
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
    );
  }
}

class _SwitchItem extends StatefulWidget {
  final bool? value;
  final Function(bool?)? onChanged;

  const _SwitchItem({
    this.value,
    this.onChanged,
  });

  @override
  State<_SwitchItem> createState() => _SwitchItemState();
}

class _SwitchItemState extends State<_SwitchItem> {
  var checked = false;

  @override
  void initState() {
    super.initState();
    checked = widget.value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: checked,
      onChanged: (value) {
        setState(() {
          checked = value;
          widget.onChanged?.call(value);
        });
      },
    );
  }
}
