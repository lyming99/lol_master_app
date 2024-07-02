import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/circle_button.dart';

class StandardItemDetailController extends MvcController {
  StatisticStandardItem? standardItem;

  List<String> items = [];

  int? editIndex;

  int get itemsCount => items.length;

  int? get itemType =>
      standardItem?.type == null ? 1 : int.parse(standardItem?.type ?? "1");

  String get titleName => standardItem?.name ?? "";

  set itemType(int? value) {
    standardItem?.type = value.toString();
    notifyListeners();
  }

  bool get hasStandardItem => standardItem != null;

  void setStandardItem(StatisticStandardItem? item) {
    standardItem = item;
    var json = item?.items ?? "";
    if (json != "") {
      var array = jsonDecode(json) as List;
      items = array.map((e) => e.toString()).toList();
    } else {
      items = [];
    }
    notifyListeners();
  }

  void updateItemType(int? value) {
    itemType = value;
    notifyListeners();
  }

  void moveUp(int index) {
    if (index > 0) {
      var temp = items[index];
      items[index] = items[index - 1];
      items[index - 1] = temp;
      notifyListeners();
      saveItems();
    }
  }

  void moveDown(int index) {
    if (index < items.length - 1) {
      var temp = items[index];
      items[index] = items[index + 1];
      items[index + 1] = temp;
      notifyListeners();
      saveItems();
    }
  }

  void deleteItem(int index) {
    items.removeAt(index);
    notifyListeners();
    saveItems();
  }

  void showRenameItemEdit(int index) {
    editIndex = index;
    notifyListeners();
  }

  void removeEditIndex() {
    editIndex = null;
    notifyListeners();
  }

  String getEditText(int index) {
    return items[index];
  }

  void updateItemName(int index, String value) {
    items[index] = value;
    saveItems();
  }

  void addItem() {
    items.add("新建选项");
    editIndex = items.length - 1;
    notifyListeners();
    saveItems();
  }


  void saveItems() {
    standardItem?.items = jsonEncode(items);
  }
}

class StandardItemDetailView extends MvcView<StandardItemDetailController> {
  const StandardItemDetailView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.hasStandardItem) {
      return Container();
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x3302f86d), Color(0x0002f86d)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Text(
                controller.titleName,
                style: TextStyle(fontSize: 16),
              ),
              Spacer(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  controller.updateItemType(1);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: Radio(
                        value: controller.itemType,
                        groupValue: 1,
                        onChanged: (value) {},
                        toggleable: false,
                      ),
                    ),
                    Text("数值型"),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () {
                  controller.updateItemType(2);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: Radio(
                        value: controller.itemType,
                        groupValue: 2,
                        onChanged: (value) {},
                        toggleable: false,
                      ),
                    ),
                    Text("布尔型"),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              InkWell(
                onTap: () {
                  controller.updateItemType(3);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      child: Radio(
                        value: controller.itemType,
                        groupValue: 3,
                        onChanged: (value) {},
                        toggleable: false,
                      ),
                    ),
                    Text("选项型"),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              Spacer(),
              if (controller.itemType == 3)
                InkWell(
                  onTap: () {
                    controller.addItem();
                  },
                  child: Icon(
                    Icons.add,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                height: 1,
                color: Colors.grey.withOpacity(.2),
              ),
              if (controller.itemType == 1)
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(text: "将此项设置为"),
                          TextSpan(
                            text: "数值型",
                            style: TextStyle(
                              color: Colors.green.shade300,
                            ),
                          ),
                          TextSpan(text: "，如果已经有数据，则重置为空"),
                        ],
                      )),
                ),
              if (controller.itemType == 2)
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        children: [
                          TextSpan(text: "将此项设置为"),
                          TextSpan(
                            text: "布尔型",
                            style: TextStyle(
                              color: Colors.purple.shade300,
                            ),
                          ),
                          TextSpan(text: "，如果已经有数据，则重置为空"),
                        ],
                      )),
                ),
              if (controller.itemType == 3)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var isFirst = index == 0;
                      var isEnd = index == controller.itemsCount - 1;
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.withOpacity(.2),
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
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
                            // 点击编辑
                            if (controller.editIndex != index)
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  child: Row(
                                    children: [
                                      CircleButton(
                                        radius: 30,
                                        onTap: () {
                                          controller.showRenameItemEdit(index);
                                        },
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
                                        width: 8,
                                      ),
                                      Text(controller.items[index]),
                                    ],
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: isFirst
                                  ? null
                                  : () {
                                      controller.moveUp(index);
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 16,
                                  color: isFirst ? Colors.grey : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            InkWell(
                              onTap: isEnd
                                  ? null
                                  : () {
                                      controller.moveDown(index);
                                    },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: isEnd ? Colors.grey : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
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
                      );
                    },
                    itemCount: controller.itemsCount,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
