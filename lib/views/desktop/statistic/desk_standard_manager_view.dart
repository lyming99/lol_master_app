import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/circle_button.dart';
import 'package:lol_master_app/widgets/popup_window.dart';

import 'manager_widgets/stadard_item_detail_view.dart';
import 'manager_widgets/stadard_item_list_view.dart';

class DeskStandardManagerController extends MvcController {
  var standardItemListController = StandardItemListController();

  var standardItemDetailController = StandardItemDetailController();

  List<StatisticStandardGroup> groupList = [];

  var showEdit = false;

  int listPopupTime = 0;

  int selectGroupIndex = 0;

  bool get hasItem => groupList.isNotEmpty;

  String get currentName => selectGroupIndex < groupList.length
      ? groupList[selectGroupIndex].name ?? "未命名标准"
      : "请创建评分标准";

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    read();
  }

  void showRenameEdit() {
    if (!hasItem) {
      return;
    }
    showEdit = true;
    notifyListeners();
  }

  void closeRenameEdit() {
    showEdit = false;
    notifyListeners();
  }

  void addGroup() {
    groupList.add(
      StatisticStandardGroup(
        name: "新建评分标准",
      ),
    );
    selectGroupIndex = groupList.length - 1;
    standardItemListController
        .setGroup(groupList[selectGroupIndex]..selected = true);
    showEdit = true;
    notifyListeners();
  }

  void updateSelectGroup(int index) {
    for (var group in groupList) {
      group.selected = false;
    }
    selectGroupIndex = index;
    standardItemListController
        .setGroup(groupList[selectGroupIndex]..selected = true);
    notifyListeners();
  }

  void updateCurrentName(String value) {
    groupList[selectGroupIndex].name = value;
  }

  void deleteGroup() {
    var remove = groupList.removeAt(selectGroupIndex);
    selectGroupIndex = 0;
    if (selectGroupIndex < groupList.length) {
      standardItemListController.setGroup(groupList[selectGroupIndex]);
    } else {
      standardItemListController.setGroup(null);
    }
    StatisticStandardService.instance.deleteGroup(remove.id);
    notifyListeners();
  }

  Future<void> save() {
    return StatisticStandardService.instance.save(groupList);
  }

  Future<void> read() async {
    groupList =
        await StatisticStandardService.instance.getStandardGroupList(true);
    selectGroupIndex = 0;
    if (selectGroupIndex < groupList.length) {
      standardItemListController.setGroup(groupList[selectGroupIndex]);
    } else {
      standardItemListController.setGroup(null);
    }
    selectGroupIndex =
        groupList.indexWhere((element) => element.selected == true);
    if (selectGroupIndex == -1) {
      selectGroupIndex = 0;
    }
    var config = await LolConfigService.instance.getCurrentConfig();
    var currentGroupId = config?.currentStandardGroupId;
    selectGroupIndex =
        groupList.indexWhere((element) => element.id == currentGroupId);
    if (selectGroupIndex == -1) {
      selectGroupIndex = 0;
    }
    updateSelectGroup(selectGroupIndex);
    notifyListeners();
  }
}

class DeskStandardManagerView extends MvcView<DeskStandardManagerController> {
  const DeskStandardManagerView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //1.按钮栏：名称显示与修改，删除按钮，保存按钮
            _ToolNav(
              controller: controller,
            ),
            //2.内容区域：过滤器，装备列表，装备存放栏
            Expanded(
              child: _Content(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 工具栏：按钮栏，各种操作按钮，名称
class _ToolNav extends StatelessWidget {
  final DeskStandardManagerController controller;

  const _ToolNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                if (controller.showEdit)
                  SizedBox(
                    width: 200,
                    height: 32,
                    child: TextField(
                      controller:
                          TextEditingController(text: controller.currentName),
                      decoration: const InputDecoration(
                        hintText: "请输入选项名称",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      autofocus: true,
                      onChanged: (value) {
                        controller.updateCurrentName(value);
                      },
                      onTapOutside: (event) {
                        controller.closeRenameEdit();
                      },
                      onSubmitted: (value) {
                        controller.closeRenameEdit();
                      },
                    ),
                  ),

                /// 修改名称
                if (!controller.showEdit)
                  CircleButton(
                    onTap: () {
                      controller.showRenameEdit();
                    },
                    radius: 15,
                    child: const SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.edit,
                        size: 24,
                      ),
                    ),
                  ),
                if (!controller.showEdit)
                  const SizedBox(
                    width: 10,
                  ),

                /// 评分标准列表
                if (!controller.showEdit)
                  Builder(builder: (context) {
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
                            Expanded(child: Text(controller.currentName)),
                            const Icon(
                              Icons.arrow_drop_down,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                if (!controller.showEdit)
                  const SizedBox(
                    width: 10,
                  ),

                /// 创建评分标准
                if (!controller.showEdit)
                  CircleButton(
                    onTap: () {
                      controller.addGroup();
                    },
                    radius: 0,
                    child: const SizedBox(
                      width: 80,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 24,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text("新建"),
                        ],
                      ),
                    ),
                  ),
              ],
            )),
            const SizedBox(
              width: 10,
            ),

            /// 删除评分标准
            CircleButton(
              onTap: () {
                showDeleteDialog(context);
              },
              radius: 15,
              child: const SizedBox(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.delete_outline,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),

            /// 创建评分标准
            CircleButton(
              onTap: () {
                controller.save();
              },
              radius: 0,
              child: const SizedBox(
                width: 60,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("保存"),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void showDeleteDialog(BuildContext context) {
    if (!controller.hasItem) {
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("删除评分标准"),
            content: Text("确定删除评分标准:${controller.currentName}？"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("取消")),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.deleteGroup();
                },
                child: const Text("确定"),
              ),
            ],
          );
        });
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

// 内容区域：过滤器，装备列表，装备存放栏
class _Content extends StatelessWidget {
  final DeskStandardManagerController controller;

  const _Content({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff404040),
        ),
      ),
      child: Row(
        children: [
          // 标准项
          Container(
            width: 200,
            child: StandardItemListView(
              controller: controller.standardItemListController,
            ),
          ),
          Container(
            width: 1,
            color: const Color(0xff404040),
          ),
          Expanded(
              child: StandardItemDetailView(
            controller: controller.standardItemDetailController,
          )),
        ],
      ),
    );
  }

  Widget buildList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 30,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xff5b5b5b),
              ),
            ),
            child: Column(
              children: [
                // 1.名称、重命名按钮、删除按钮、上下调节按钮
                Row(
                  children: [],
                ),
                // 2.评分类型：数值型，布尔型，选项型
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
