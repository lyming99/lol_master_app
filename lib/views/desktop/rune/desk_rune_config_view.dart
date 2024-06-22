import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_config_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/widgets/rune/rune_background_widget.dart';

import '../../../entities/rune/rune.dart';
import 'rune_item_widget.dart';

class DeskRuneConfigView extends MvcView<DeskRuneConfigController> {
  const DeskRuneConfigView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FittedBox(
        child: SizedBox(
          width: 1162,
          height: 720,
          child: Stack(
            children: [
              // 背景
              RuneBackgroundWidget(
                name: controller.selectPrimaryRuneKey,
                showRune: controller.isPrimarySelectAll,
              ),
              // 名称和保存按钮
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    // 名称
                    if (controller.renameEditable)
                      Container(
                        width: 240,
                        height: 40,
                        child: Builder(builder: (context) {
                          return TextField(
                            controller: controller.configNameController,
                            autofocus: true,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            decoration: InputDecoration(
                              hintText: "未命名符文",
                              hintStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 232, 190, 114))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Color.fromARGB(255, 232, 190, 114))),
                            ),
                            cursorColor: Color.fromARGB(255, 232, 190, 114),
                            onSubmitted: (value) {
                              controller.config.configName = value;
                              controller.hideRenameEdit();
                            },
                            onChanged: (value) {
                              controller.config.configName = value;
                              controller.setSaveEnable(true);
                            },
                            onTapOutside: (event) {
                              controller.hideRenameEdit();
                            },
                          );
                        }),
                      ),
                    if (!controller.renameEditable)
                      InkWell(
                        onTap: () {
                          controller.showRenameEdit();
                        },
                        child: Container(
                          width: 240,
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                child: Text(
                                  controller.configName ?? "未命名符文",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      width: 20,
                    ),
                    // 保存按钮
                    Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: controller.saveEnable == false
                              ? Color.fromARGB(255, 30, 37, 61)
                              : Color.fromARGB(255, 30, 37, 61),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: controller.saveEnable == false
                                  ? Color.fromARGB(255, 53, 40, 15)
                                  : Color.fromARGB(255, 232, 190, 114))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.saveEnable == false
                              ? null
                              : () {
                                  controller.saveConfig();
                                },
                          child: Center(
                            child: Text(
                              "保存",
                              style: TextStyle(
                                  color: controller.saveEnable == false
                                      ? Color.fromARGB(255, 139, 139, 136)
                                      : Color.fromARGB(255, 243, 227, 199),
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    // 删除按钮
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 30, 37, 61),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Color.fromARGB(255, 232, 190, 114)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            showDeleteConfigDialog(context);
                          },
                          child: const Center(
                            child: Icon(
                              Icons.delete_outline,
                              color: Color.fromARGB(255, 243, 227, 199),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 符文内容区域
              Container(
                margin: EdgeInsets.only(top: 120),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                      ),
                      // 主系符文
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: buildPrimaryRuneGroupList(context),
                            ),
                            Container(
                              height: 70,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "    基石",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            for (var i = 0;
                                i < controller.primaryRunes.length;
                                i++)
                              Row(
                                children: [
                                  for (var j = 0;
                                      j < controller.primaryRunes[i].length;
                                      j++)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 24, horizontal: 16),
                                      child: RuneConfigItemWidget(
                                        item: controller.primaryRunes[i][j],
                                        selected: controller
                                            .primaryRunes[i][j].selected,
                                        onTap: (item) {
                                          controller.selectPrimaryRune(i, j);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      // 副系符文
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: buildSecondaryRuneGroupList(context),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            for (var i = 1;
                                i < controller.secondaryRunes.length;
                                i++)
                              Row(
                                children: [
                                  for (var j = 0;
                                      j < controller.secondaryRunes[i].length;
                                      j++)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 16),
                                      child: RuneConfigItemWidget(
                                        item: controller.secondaryRunes[i][j],
                                        selected: controller
                                            .secondaryRunes[i][j].selected,
                                        onTap: (item) {
                                          controller.selectSecondaryRune(i, j);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            for (var i = 0;
                                i < controller.thirdRunes.length;
                                i++)
                              Row(
                                children: [
                                  for (var j = 0;
                                      j < controller.thirdRunes[i].length;
                                      j++)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 24),
                                      child: RuneConfigItemWidget(
                                        item: controller.thirdRunes[i][j],
                                        selected: controller
                                            .thirdRunes[i][j].selected,
                                        size: 32,
                                        onTap: (item) {
                                          controller.selectThirdRune(i, j);
                                        },
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPrimaryRuneGroupList(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < controller.primaryRuneGroupList.length; i++) {
      list.add(RuneGroupItemWidget(
        item: controller.primaryRuneGroupList[i],
        selected: controller.primaryRuneGroupList[i].selected,
        onTap: (item) {
          controller.selectPrimaryRuneGroup(i);
        },
      ));
    }
    return list;
  }

  List<Widget> buildSecondaryRuneGroupList(BuildContext context) {
    List<Widget> list = [];
    for (var i = 0; i < controller.secondaryRuneGroupList.length; i++) {
      list.add(RuneGroupItemWidget(
        item: controller.secondaryRuneGroupList[i],
        selected: controller.secondaryRuneGroupList[i].selected,
        onTap: (item) {
          controller.selectSecondaryRuneGroup(i);
        },
      ));
    }
    return list;
  }

  void showDeleteConfigDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("删除配置"),
            content: Text("确定删除当前配置？"),
            backgroundColor: Color.fromARGB(255, 2, 23, 29),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("取消"),
              ),
              TextButton(
                onPressed: () async {
                  await controller.deleteConfig();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text("确定"),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color:Color.fromARGB(255, 168, 121, 8))
            ),
          );
        });
  }
}

class RuneConfigItemWidget extends StatefulWidget {
  final RuneConfigItem item;
  final Function(RuneConfigItem item)? onTap;
  final bool? selected;
  final double size;

  const RuneConfigItemWidget({
    super.key,
    required this.item,
    this.onTap,
    this.size = 48,
    this.selected,
  });

  @override
  State<RuneConfigItemWidget> createState() => _RuneConfigItemWidgetState();
}

class _RuneConfigItemWidgetState extends State<RuneConfigItemWidget> {
  @override
  void didUpdateWidget(covariant RuneConfigItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var selected = widget.item.selected == true;
    return InkWell(
      onTap: () {
        setState(() {
          widget.onTap?.call(widget.item);
        });
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(60),
        ),
        child: createRuneItemTooltip(
            context,
            widget.item,
            Image.asset(
              widget.item.icon ?? "",
              color: selected ? null : Colors.grey.shade900.withOpacity(0.4),
              colorBlendMode: selected ? null : BlendMode.srcATop,
            )),
      ),
    );
  }
}

class RuneGroupItemWidget extends StatefulWidget {
  final RuneGroupItem item;
  final bool? selected;
  final Function(RuneGroupItem item)? onTap;

  const RuneGroupItemWidget({
    super.key,
    required this.item,
    this.onTap,
    this.selected,
  });

  @override
  State<RuneGroupItemWidget> createState() => _RuneGroupItemWidgetState();
}

class _RuneGroupItemWidgetState extends State<RuneGroupItemWidget> {
  @override
  void didUpdateWidget(covariant RuneGroupItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onTap?.call(widget.item);
        });
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                widget.item.selected == true ? Colors.blue : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(48),
        ),
        child: Image.asset(
          widget.item.icon ?? "",
        ),
      ),
    );
  }
}
