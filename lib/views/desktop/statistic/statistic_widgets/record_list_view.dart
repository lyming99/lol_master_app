import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_record_list_controller.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/circle_button.dart';
import 'package:lol_master_app/widgets/popup_dialog.dart';
import 'package:lol_master_app/widgets/popup_window.dart';
import 'package:lol_master_app/widgets/table/table_filter_widget.dart';
import 'package:lol_master_app/widgets/table/table_widget.dart';
import 'package:re_editor/re_editor.dart';

import 'score_popup_window.dart';

/// 评分记录列表
/// 表头
/// 数据
/// 分页
/// 1. 如何计算列宽？
/// 列宽 = max(titleWidth,cellWidths:80)
/// 数值型80、布尔型(下拉80)、下拉框选择型(80)，备注(占用剩余宽度，最小100)
/// 2. 如何计算行高？
/// 行高固定即可：50
/// 3.有哪些列？
/// 默认数据：序号，使用英雄(下拉筛选)，段位，开始时间，对局耗时，召唤师技能，符文，kda，
/// 输出占比，承伤占比，推塔数量，补刀数量，备注
/// 自定义数据：序号，使用英雄(下拉筛选)，段位，开始时间，对局耗时，各项自定义数据，备注(占用剩余宽度，最小100)
/// 4.设计数据结构？
/// 表头数据：列宽，列名，列类型，列数据
/// 内容数据：文字型、数值型、下拉框型，是否可以编辑
class DeskRecordListView extends MvcView<DeskRecordListController> {
  const DeskRecordListView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return MyTableWidget(
      controller: controller.tableController,
      headerBuilder: (context, index) {
        return buildHeaderWidget(context, index);
      },
      cellBuilder: (context, rowIndex, colIndex) {
        var cell = controller.tableController.rows[rowIndex].cells[colIndex];
        return buildCellWidget(context, cell);
      },
    );
  }

  Widget buildHeaderWidget(
    BuildContext context,
    int colIndex,
  ) {
    var header = controller.tableController.headers[colIndex];
    return Builder(builder: (context) {
      return SizedBox(
        width: header.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(header.name),
            if (controller.hasFilter(header)) const SizedBox(width: 8),
            if (controller.hasFilter(header))
              SizedBox(
                width: 16,
                height: 16,
                child: CircleButton(
                  radius: 20,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 12,
                  ),
                  onTap: () {
                    if (header.columnType == ColumnType.hero.name) {
                      showHeroDropMenu(context);
                    }
                    if (header.columnType == ColumnType.rankLevel.name) {
                      showRankLevelDropMenu(context);
                    }
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget buildCellWidget(
    BuildContext context,
    MyCellItem cell,
  ) {
    var header = controller.tableController.headers[cell.colIndex];
    if (header.columnType == ColumnType.hero.name) {
      return buildHeroCellWidget(context, cell);
    }
    if (header.columnType == ColumnType.rankLevel.name) {
      return buildRankLevelWidget(context, cell);
    }
    if (header.columnType == ColumnType.kda.name) {
      return buildKdaWidget(context, cell);
    }
    if (header.columnType == ColumnType.score.name) {
      return buildScoreWidget(context, cell);
    }
    if (header.columnType == ColumnType.remark.name) {
      return buildRemarkWidget(context, cell);
    }
    if (header.columnType == ColumnType.detail.name) {
      return buildDetailLinkWidget(context, cell);
    }
    if (header.columnType == ColumnType.gameResult.name) {
      return buildGameResultWidget(context, cell);
    }
    return buildNormalWidget(context, cell);
  }

  SizedBox buildNormalWidget(BuildContext context, MyCellItem cell) {
    return SizedBox(
      width: getCellWidth(cell),
      child: Center(child: Text(cell.value.toString())),
    );
  }

  SizedBox buildGameResultWidget(BuildContext context, MyCellItem cell) {
    return SizedBox(
      width: getCellWidth(cell),
      child: Center(
          child: Text(
        cell.value.toString(),
        style: TextStyle(
          color: cell.value.toString() == "胜利" ? Colors.green : Colors.red,
        ),
      )),
    );
  }

  SizedBox buildDetailLinkWidget(BuildContext context, MyCellItem cell) {
    return SizedBox(
      width: getCellWidth(cell),
      child: Center(
        child: TextButton(
          onPressed: () {
            showDetailDialog(context, cell);
          },
          child: Text("详细数据"),
        ),
      ),
    );
  }

  SizedBox buildRemarkWidget(BuildContext context, MyCellItem cell) {
    return SizedBox(
      width: getCellWidth(cell),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          CircleButton(
            onTap: () {
              showRemarkDialog(context, cell);
            },
            radius: 20,
            child: SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.edit,
                size: 16,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(cell.value == null || cell.value.isEmpty
                  ? "未备注"
                  : cell.value)),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  SizedBox buildScoreWidget(BuildContext context, MyCellItem cell) {
    return SizedBox(
      width: getCellWidth(cell),
      child: Center(
        child: CircleButton(
          onTap: () {
            showScoreDialog(context, cell);
          },
          radius: 20,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              Icons.edit,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildKdaWidget(BuildContext context, MyCellItem cell) {
    return SizedBox(
      width: getCellWidth(cell),
      child: Center(
        child: Text(
          (cell.value as List).join("/"),
        ),
      ),
    );
  }

  double getCellWidth(MyCellItem cell) {
    var cellWidth = controller.tableController.headers[cell.colIndex].width;
    return cellWidth;
  }

  SizedBox buildRankLevelWidget(BuildContext context, MyCellItem cell) {
    double width = getCellWidth(cell);
    return SizedBox(
      width: width,
      child: Center(
        child: Text(
          (cell.value as List).join(),
        ),
      ),
    );
  }

  SizedBox buildHeroCellWidget(BuildContext context, MyCellItem cell) {
    double width = getCellWidth(cell);
    var heroInfo = cell.value as HeroInfo?;
    var iconUrl = heroInfo?.iconUrl;
    if (iconUrl != null) {
      return SizedBox(
        width: width,
        child: Tooltip(
          message: heroInfo?.name,
          child: Image.asset(
            iconUrl,
            width: 32,
            height: 32,
          ),
        ),
      );
    }
    return SizedBox(
      width: width,
      child: const Center(
        child: Text("未知英雄"),
      ),
    );
  }

  void showHeroDropMenu(BuildContext context) {
    showCustomDropMenu(
      context: context,
      modal: true,
      width: 300,
      height: 300,
      builder: (context) {
        return TableFilterWidget(
          hintText: "搜索英雄",
          controller: controller.filterControllerMap["hero"]!,
          onChanged: () {
            controller.refreshTable();
          },
          itemBuilder: (context, value) {
            var heroInfo = value as HeroInfo;
            return Row(
              children: [
                Image.asset(
                  heroInfo.iconUrl ?? "",
                  width: 24,
                  height: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  heroInfo.name ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showRankLevelDropMenu(BuildContext context) {
    showCustomDropMenu(
      context: context,
      modal: true,
      width: 300,
      height: 300,
      builder: (context) {
        return TableFilterWidget(
          hintText: "搜索段位",
          controller: controller.filterControllerMap["rankLevel"]!,
          onChanged: () {
            controller.refreshTable();
          },
          itemBuilder: (context, value) {
            return Text(
              value.toString(),
              style: const TextStyle(fontSize: 14),
            );
          },
        );
      },
    );
  }

  void showScoreDialog(BuildContext context, MyCellItem cell) {
    var stdId = controller.getStandardGroupId(context);
    showMyCustomDialog(
      context: context,
      builder: (context) {
        return ScorePopupWindow(
          controller: ScorePopupController(
            gameId: controller.getGameId(cell),
            standardId: stdId,
          ),
        );
      },
    ).then((value) => controller.refreshTable());
  }

  void showRemarkDialog(BuildContext context, MyCellItem cell) {
    showMyCustomDialog(
        context: context,
        windowSize: const Size(400, 320),
        builder: (context) {
          var codeController =
              CodeLineEditingController.fromText(cell.value?.toString() ?? "");
          return Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: CodeEditor(
                      controller: codeController,
                      hint: "请输入备注内容",
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 80,
                        height: 32,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: CircleButton(
                          radius: 4,
                          onTap: () {
                            codeController.text = "";
                          },
                          child: const Center(child: Text("清空")),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 32,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: CircleButton(
                          radius: 4,
                          onTap: () {
                            controller.updateGameNote(
                                cell.rowIndex, codeController.text);
                            Navigator.pop(context);
                          },
                          child: const Center(child: Text("保存")),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  void showDetailDialog(BuildContext context, MyCellItem cell) {
    showMyCustomDialog(
        context: context,
        builder: (context) {
          return Container();
        });
  }
}
