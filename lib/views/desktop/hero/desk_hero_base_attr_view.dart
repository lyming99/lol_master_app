import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_base_attr_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/label_title_widget.dart';

/// 英雄数值视图
class DeskHeroBaseAttrView extends MvcView<DeskHeroBaseAttrController> {
  const DeskHeroBaseAttrView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 16,
        ),
        // 数值标题
        LabelTitleWidget(
          title: "数值",
          action: TextButton(
            onPressed: () {},
            child: Text("英雄对比"),
          ),
        ),
        const SizedBox(height: 16),
        // 等级
        Row(
          children: [
            Container(
              alignment: Alignment.centerRight,
              width: 60,
              child: Text(
                "等级: ${controller.heroLevel}",
              ),
            ),
            Expanded(
              child: Slider(
                value: controller.heroLevel.toDouble(),
                onChanged: (value) {
                  controller.updateLevel(value);
                },
                min: 1,
                max: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 英雄属性
        Wrap(
          children: [
            for (var attr in controller.heroAttrs)
              _HeroAttrWidget(
                name: attr.name,
                value: attr.value,
              ),
          ],
        ),
      ],
    );
  }
}

class _HeroAttrWidget extends StatelessWidget {
  final String? name;
  final String? value;

  const _HeroAttrWidget({
    super.key,
    this.name,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 80,
      height: 80,
      margin: EdgeInsets.all(1),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(value ?? "100"),
          SizedBox(
            height: 4,
          ),
          Text(name ?? "生命"),
        ],
      ),
    );
  }
}
