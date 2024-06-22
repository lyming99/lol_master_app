import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_equip_controller.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/grid_view_fix_size.dart';

/// 英雄出装视图
class DeskHeroEquipView extends MvcView<DeskHeroEquipController> {
  const DeskHeroEquipView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.equipList.length,
            itemBuilder: (context, index) {
              return EquipConfigListItemWidget(
                equipConfig: controller.equipList[index],
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedSize(
              itemWidth: 300,
              itemHeight: 260,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              fixOneItem: true,
            ),
          ),
        )
      ],
    );
  }
}

class EquipConfigListItemWidget extends StatelessWidget {
  final EquipConfig equipConfig;

  const EquipConfigListItemWidget({super.key, required this.equipConfig});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 23, 53, 86),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${equipConfig.name}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 1,
            margin: EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey.shade500,
          ),
          for (var equipGroup in equipConfig.equipGroupList ?? <EquipGroup>[])
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 60,
                  child: Title3Widget(
                    title: "出门装",
                  ),
                ),
                for (var item in equipGroup.equipList ?? <EquipInfo>[])
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Image.asset(
                      item.icon ?? "",
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class Title3Widget extends StatelessWidget {
  final String? title;

  const Title3Widget({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 24,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "$title",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
