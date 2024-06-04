import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_list_controller.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';
// 装备列表
class DeskEquipListView  extends MvcView<DeskEquipListController>{
  const DeskEquipListView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            maxCrossAxisExtent: 120,
          ),
          itemBuilder: (context, index) {
            return EquipItemWidget(equipInfo: controller.equipFilterList[index]);
          },
          itemCount: controller.equipFilterList.length,
        ),
      ),
    ],);
  }
}

class EquipItemWidget  extends StatelessWidget {
  final  EquipInfo equipInfo;
  const EquipItemWidget({super.key,
    required this.equipInfo,
  });
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: equipInfo.desc,
      child: Column(children: [
        Image.asset(
          "assets/lol/img/item/${equipInfo.itemId}.png",
          width: 60,
          height: 60,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          "${equipInfo.name}",
          style: TextStyle(fontSize: 12),
        ),
      ],),
    );
  }


}