import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_config_controller.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/grid_view_fix_size.dart';

import 'desk_equip_list_view.dart';

// 装备配置界面
class DeskEquipConfigView extends MvcView<DeskEquipConfigController> {
  const DeskEquipConfigView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
    );
  }
}

// 工具栏：按钮栏，各种操作按钮，名称
class _ToolNav extends StatelessWidget {
  final DeskEquipConfigController controller;

  const _ToolNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                controller.isShowRenameEdit
                    ? SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          controller: controller.nameEditController,
                          focusNode: controller.nameEditFocusNode,
                          autofocus: true,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: "请输入装配方案名称",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 232, 190, 114))),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 232, 190, 114))),
                          ),
                          cursorColor: Color.fromARGB(255, 232, 190, 114),
                          onSubmitted: (value) {
                            controller.setShowRenameEdit(false);
                          },
                          onChanged: (value) {
                            controller.updateName(value);
                          },
                          onTapOutside: (e) {
                            controller.setShowRenameEdit(false);
                          },
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          controller.setShowRenameEdit(true);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                controller.equipName,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.edit,
                                size: 18,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            )),
            IconButton(
                onPressed: () {
                  showDeleteDialog(context);
                },
                icon: Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  controller.saveConfig();
                },
                icon: Icon(Icons.save)),
          ],
        ));
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("删除装配方案"),
            content: Text("确定删除装配方案？"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("取消")),
              TextButton(
                onPressed: () {
                  controller.deleteConfig();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("确定"),
              ),
            ],
          );
        });
  }
}

// 内容区域：过滤器，装备列表，装备存放栏
class _Content extends StatelessWidget {
  final DeskEquipConfigController controller;

  const _Content({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterPane(
          controller: controller,
        ),
        Expanded(
            flex: 2,
            child: _EquipListPane(
              controller: controller,
            )),
        Expanded(
            flex: 3,
            child: _EquipPlacePane(
              controller: controller,
            )),
      ],
    );
  }
}

// 过滤器区域
class _FilterPane extends StatelessWidget {
  final DeskEquipConfigController controller;

  const _FilterPane({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.clearFilter();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      SizedBox(
                        width: 4,
                      ),
                      Text("清空"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                for (var filter in controller.filters)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CheckboxMenuButton(
                      value: filter.isChecked,
                      child: Text(filter.name),
                      onChanged: (value) {
                        controller.updateFilterChecked(filter, value ?? false);
                      },
                    ),
                  ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// 装备列表区域
class _EquipListPane extends StatelessWidget {
  final DeskEquipConfigController controller;

  const _EquipListPane({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 32,
                  child: TextField(
                    controller: controller.searchEditController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "装备搜索",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 232, 190, 114))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 232, 190, 114))),
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      suffixIconConstraints: BoxConstraints(maxWidth: 20),
                    ),
                    cursorColor: Color.fromARGB(255, 232, 190, 114),
                    onChanged: (value) {
                      controller.search(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(vertical: 4),
          ),
          Expanded(
            child: DeskEquipListView(
              controller: controller.equipListController,
              showSearchWidget: false,
              iconSize: 48,
              labelFontSize: 12,
              padding: EdgeInsets.symmetric(vertical: 10),
              spacing: 10,
              showLabel: false,
              onClickEquip: (info) {
                controller.showEquipTree(info);
              },
            ),
          ),
          if (controller.isShowEquipTree)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0x66767676),
                ),
              ),
              child: EquipTree(
                controller: controller,
              ),
            )
        ],
      ),
    );
  }
}

// 装备存放栏
class _EquipPlacePane extends StatefulWidget {
  final DeskEquipConfigController controller;

  const _EquipPlacePane({required this.controller});

  @override
  State<_EquipPlacePane> createState() => _EquipPlacePaneState();
}

class _EquipPlacePaneState extends State<_EquipPlacePane> {
  var scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(updateState);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.removeListener(updateState);
  }

  void updateState() {
    print('state changed...');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var maxHeight = cons.maxHeight - 140;
      maxHeight = min(
          widget.controller.calculateEquipGroupHeight(cons.maxWidth - 40),
          maxHeight);
      return Column(
        children: [
          //1.区块列表
          Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: ListView.builder(
              controller: scrollController,
              itemBuilder: (context, index) {
                return _EquipGroupContainer(
                  controller: widget.controller,
                  equipGroup: widget.controller.getEquipGroup(index),
                  isFirstItem: index == 0,
                  isLastItem: index == widget.controller.equipGroupCount - 1,
                );
              },
              itemCount: widget.controller.equipGroupCount,
            ),
          ),
          // 2.拖入检测区域
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0x66767676), width: 2)),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DragTarget(
              builder: buildDragInContainer,
              onWillAcceptWithDetails: (details) {
                return details.data is EquipInfo;
              },
              onAcceptWithDetails: (details) {
                var data = details.data;
                if (data is EquipInfo) {
                  widget.controller.addEquipGroup(data);
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget buildDragInContainer(context, candidateData, rejectedData) {
    return Container(
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
          ),
          Icon(
            Icons.drag_indicator_sharp,
            color: Color(0x66767676),
            size: 64,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              "将装备拖入此处以创建一个新的区块",
              style: TextStyle(color: Color(0xffe8be72)),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class EquipTree extends StatelessWidget {
  final DeskEquipConfigController controller;

  const EquipTree({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          Expanded(child: Text("装备树")),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                controller.setShowEquipTree(false);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipGroupContainer extends StatefulWidget {
  final DeskEquipConfigController controller;
  final EquipGroup equipGroup;
  final bool isFirstItem;
  final bool isLastItem;

  const _EquipGroupContainer({
    required this.controller,
    required this.equipGroup,
    required this.isFirstItem,
    required this.isLastItem,
  });

  @override
  State<_EquipGroupContainer> createState() => _EquipGroupContainerState();
}

class _EquipGroupContainerState extends State<_EquipGroupContainer> {
  Rect? dragInRect;
  int? insertIndex;
  var isShowGroupEdit = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      var width = cons.maxWidth;
      int colCount = widget.controller.getColCount(width - 40);
      int rowCount = ((widget.equipGroup.equipList.length) / colCount).ceil();
      rowCount = max(1, rowCount);
      int endColCount = (widget.equipGroup.equipList.length) % colCount;
      if (endColCount == 0 && rowCount > 1) {
        endColCount = colCount;
      }
      var height = rowCount * 68.0 + (rowCount + 1) * 10;
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0x66767676), width: 2),
        ),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            // 1.头部
            Container(
              height: 40,
              child: Row(
                children: [
                  if (!isShowGroupEdit)
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      onPressed: () {
                        showGroupEdit();
                      },
                    ),
                  if (!isShowGroupEdit)
                    Expanded(
                      child: Text(
                        widget.equipGroup.name ?? "新的区块",
                        style: TextStyle(color: Color(0xffe8be72)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (isShowGroupEdit)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: TextField(
                          controller: TextEditingController(
                              text: widget.equipGroup.name),
                          decoration: InputDecoration(
                            hintText: "区块名称",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          autofocus: true,
                          onChanged: (value) {
                            widget.equipGroup.name = value;
                          },
                          onTapOutside: (event) {
                            setState(() {
                              isShowGroupEdit = false;
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              isShowGroupEdit = false;
                            });
                          },
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: widget.isFirstItem
                        ? null
                        : () {
                            widget.controller.moveGroupUp(widget.equipGroup);
                          },
                    icon: Icon(Icons.arrow_drop_up),
                  ),
                  IconButton(
                    onPressed: widget.isLastItem
                        ? null
                        : () {
                            widget.controller.moveGroupDown(widget.equipGroup);
                          },
                    icon: Icon(Icons.arrow_drop_down),
                  ),
                  IconButton(
                    onPressed: () {
                      widget.controller.removeEquipGroup(widget.equipGroup);
                    },
                    icon: Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            // 2.装备列表
            Container(
              height: height,
              child: DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return Stack(
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedSize(
                          itemWidth: 48,
                          itemHeight: 68,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          var equipInfo = widget.equipGroup.equipList[index];
                          return EquipItemWidget(
                            equipInfo: equipInfo,
                            iconSize: 48,
                          );
                        },
                        itemCount: widget.equipGroup.equipList.length,
                      ),
                      if (dragInRect != null)
                        Positioned(
                          left: dragInRect!.left,
                          top: dragInRect!.top,
                          child: Container(
                            width: dragInRect!.width,
                            height: dragInRect!.height,
                            color: const Color(0xfff1ac27),
                          ),
                        ),
                    ],
                  );
                },
                onMove: (event) {
                  var box = context.findRenderObject();
                  if (box is RenderBox) {
                    // 5,5--(58*col,78*row)
                    var dragOffset = box.globalToLocal(event.offset);
                    int colIndex = ((dragOffset.dx - 5) / 58).round();
                    int rowIndex = ((dragOffset.dy - 5) / 78).floor();
                    if (colIndex < 0) {
                      colIndex = 0;
                    }
                    if (rowIndex < 0) {
                      rowIndex = 0;
                    }
                    if (rowIndex == rowCount - 1 || rowCount == 0) {
                      if (colIndex > endColCount) {
                        colIndex = endColCount;
                      }
                    }
                    insertIndex = rowIndex * colCount + colIndex;
                    dragInRect = Rect.fromLTWH(
                        colIndex * 58 + 5, rowIndex * 78 + 5, 2, 78);
                    setState(() {
                      print('$dragOffset');
                    });
                  }
                },
                onWillAcceptWithDetails: (details) {
                  return details.data is EquipInfo;
                },
                onAcceptWithDetails: (details) {
                  var equipInfo = details.data as EquipInfo;
                  widget.controller.addEquipInfo(
                      widget.equipGroup, equipInfo, insertIndex ?? 0);
                  setState(() {
                    dragInRect = null;
                  });
                },
                onLeave: (d) {
                  setState(() {
                    dragInRect = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void showGroupEdit() {
    setState(() {
      isShowGroupEdit = true;
    });
  }
}
