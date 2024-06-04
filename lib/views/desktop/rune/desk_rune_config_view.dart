import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_config_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/widgets/rune/rune_background_widget.dart';

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
              RuneBackgroundWidget(name: controller.selectPrimaryRuneKey,showRune: controller.isPrimarySelectAll,),
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
        child: Image.asset(
          widget.item.icon ?? "",
          color: selected ? null : Colors.grey.shade900.withOpacity(0.8),
          colorBlendMode: selected ? null : BlendMode.srcATop,
        ),
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
