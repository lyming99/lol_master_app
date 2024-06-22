import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_list_controller.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/grid_view_fix_size.dart';
import 'package:lol_master_app/widgets/tooltip.dart';
import 'dart:ui' as ui
    show
        Paragraph,
        ParagraphBuilder,
        ParagraphConstraints,
        ParagraphStyle,
        PlaceholderAlignment,
        TextStyle;

// 装备列表
class DeskEquipListView extends MvcView<DeskEquipListController> {
  final bool showSearchWidget;
  final double labelFontSize;
  final double iconSize;
  final EdgeInsets padding;
  final double spacing;
  final bool showLabel;
  final Function(EquipInfo equipInfo)? onClickEquip;

  const DeskEquipListView({
    super.key,
    required super.controller,
    this.showSearchWidget = true,
    this.iconSize = 60,
    this.labelFontSize = 12,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16,
    this.showLabel = true,
    this.onClickEquip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showSearchWidget)
          Material(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 40),
              margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: TextField(
                controller: controller.searchController,
                decoration: const InputDecoration(
                  hintText: "搜索装备",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (value) {
                  controller.filterEquip();
                },
              ),
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: padding,
            gridDelegate: SliverGridDelegateWithFixedSize(
              itemWidth: iconSize + 4,
              itemHeight: showLabel ? iconSize + 20 : iconSize + 4,
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
            ),
            itemBuilder: (context, index) {
              return EquipItemWidget(
                equipInfo: controller.equipFilterList[index],
                iconSize: iconSize,
                labelFontsize: labelFontSize,
                showLabel: showLabel,
                onClick: () {
                  onClickEquip?.call(controller.equipFilterList[index]);
                },
              );
            },
            itemCount: controller.equipFilterList.length,
          ),
        ),
      ],
    );
  }
}

class EquipItemWidget extends StatelessWidget {
  final EquipInfo equipInfo;
  final double iconSize;
  final double labelFontsize;
  final bool showLabel;
  final VoidCallback? onClick;
  final bool dragEnable;

  const EquipItemWidget({
    super.key,
    required this.equipInfo,
    this.iconSize = 60,
    this.labelFontsize = 12,
    this.showLabel = true,
    this.onClick,
    this.dragEnable = true,
  });

  @override
  Widget build(BuildContext context) {
    var text = "${equipInfo.desc}"
        .replaceAll(RegExp("<br[^>]*>"), "\n")
        .replaceAll(RegExp("<[^>]*>"), "")
        .trim();
    var span =
        TextSpan(style: TextStyle(fontFamily: "微软雅黑", fontSize: 12), children: [
      TextSpan(
          text: "${equipInfo.name}\n\n",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )),
      TextSpan(
        text: "购买价格:",
      ),
      TextSpan(
        text: "${equipInfo.price}",
        style: TextStyle(color: Colors.amber),
      ),
      TextSpan(
        text: "\t出售价格:",
      ),
      TextSpan(
        text: "${equipInfo.sell}\n\n",
        style: TextStyle(color: Colors.amber),
      ),
      TextSpan(
        text: text,
      ),
    ]);
    var painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout(maxWidth: 178);
    var height = 24 + painter.height;
    var content = GestureDetector(
      onTap: onClick,
      child: Stack(
        children: [
          Align(
            alignment: showLabel ? Alignment.topCenter : Alignment.center,
            child: CustomTooltip(
              tipWidth: 200,
              tipHeight: height,
              tipBuilder: (BuildContext context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 8, 29, 43),
                    border: Border.all(
                      color: Color.fromARGB(255, 144, 91, 59),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                    text: span,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Color(0xFF574729),
                )),
                child: Image.asset(
                  "assets/lol/img/item/${equipInfo.itemId}.png",
                  width: iconSize,
                  height: iconSize,
                ),
              ),
            ),
          ),
          if (showLabel)
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "${equipInfo.name}",
                style: TextStyle(fontSize: labelFontsize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
    if (!dragEnable) {
      return content;
    }
    return Draggable(
      data: equipInfo,
      feedback: Opacity(
        opacity: 0.8,
        child: Image.asset(
          "assets/lol/img/item/${equipInfo.itemId}.png",
          width: iconSize,
          height: iconSize,
        ),
      ),
      child: content,
    );
  }
}
