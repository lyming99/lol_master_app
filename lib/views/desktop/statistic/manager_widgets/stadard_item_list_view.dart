import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/statistic/desk_standard_manager_view.dart';
import 'package:lol_master_app/widgets/circle_button.dart';

import 'stadard_item_detail_view.dart';

class StandardItemListController extends MvcController {
  StandardItemDetailController? standardItemDetailController;
  StatisticStandardGroup? group;

  var selectIndex = 0;

  int? editIndex;

  String get groupName => group?.name ?? "";

  bool get hasGroup => group != null;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    var controller = MvcController.of(context);
    if (controller is DeskStandardManagerController) {
      standardItemDetailController = controller.standardItemDetailController;
    }
  }

  List<StatisticStandardItem> get items => group?.items ?? [];

  int get itemsCount => items.length;

  void updateSelectIndex(int index) {
    selectIndex = index;
    if (index < itemsCount) {
      standardItemDetailController?.setStandardItem(items[index]);
    } else {
      standardItemDetailController?.setStandardItem(null);
    }
    notifyListeners();
  }

  void renameItem(int index) {
    editIndex = index;
    notifyListeners();
  }

  void removeEditIndex() {
    editIndex = null;
    notifyListeners();
  }

  void updateItemName(int index, String value) {
    items[index].name = value;
    if (index == selectIndex) {
      standardItemDetailController?.setStandardItem(items[index]);
    }
  }

  String getEditText(int index) {
    return items[index].name ?? "";
  }

  void addItem() {
    items.add(
      StatisticStandardItem(
        groupId: group?.id,
        name: "新建评分项",
      ),
    );
    editIndex = items.length - 1;
    updateSelectIndex(items.length - 1);
    notifyListeners();
  }

  void deleteItem(int index) {
    if (index == selectIndex) {
      standardItemDetailController?.setStandardItem(null);
    }
    items.removeAt(index);
    notifyListeners();
  }

  void setGroup(StatisticStandardGroup? group) {
    // 查询分组下的item列表
    this.group = group;

    updateSelectIndex(0);
    notifyListeners();
  }
}

class StandardItemListView extends MvcView<StandardItemListController> {
  const StandardItemListView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.hasGroup) {
      return Container();
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x33f802a2), Color(0x0002f86d)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Text(
                controller.groupName,
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  controller.addItem();
                },
                child: const Icon(
                  Icons.add,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (controller.editIndex == index)
                    ? null
                    : () {
                        controller.updateSelectIndex(index);
                      },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(.2),
                      ),
                    ),
                    gradient: index != controller.selectIndex
                        ? null
                        : LinearGradient(
                            colors: [Color(0x3302f86d), Color(0x0002f86d)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 8,
                      ),
                      if (controller.editIndex != index)
                        Expanded(
                            child: Row(
                          children: [
                            CircleButton(
                              radius: 30,
                              onTap: () {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  controller.renameItem(index);
                                });
                              },
                              child: const SizedBox(
                                width: 24,
                                height: 24,
                                child: Icon(
                                  Icons.edit,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                controller.getEditText(index),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        )),
                      if (controller.editIndex == index)
                        Expanded(
                          child: SizedBox(
                            height: 32,
                            child: TextField(
                              controller: TextEditingController(
                                  text: controller.getEditText(index)),
                              decoration: const InputDecoration(
                                hintText: "请输入选项名称",
                                border: OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                              ),
                              autofocus: true,
                              onChanged: (value) {
                                controller.updateItemName(index, value);
                              },
                              onTapOutside: (event) {
                                controller.removeEditIndex();
                              },
                              onSubmitted: (value) {
                                controller.removeEditIndex();
                                controller.updateItemName(index, value);
                              },
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          controller.deleteItem(index);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.delete_outline, size: 16),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: controller.itemsCount,
          ),
        ),
      ],
    );
  }
}
