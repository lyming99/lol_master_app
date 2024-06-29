import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_config_controller.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_config_list_controller.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/equip/desk_equip_config_view.dart';
import 'package:lol_master_app/views/desktop/equip/desk_equip_list_view.dart';
import 'package:lol_master_app/widgets/grid_view_fix_size.dart';

class DeskEquipConfigListView extends MvcView<DeskEquipConfigListController> {
  const DeskEquipConfigListView({
    super.key,
    required super.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Row(
            children: [
              //搜索符文
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "搜索装配方案",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    ),
                    onChanged: (value) {
                      controller.search(value);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xff091b20),
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(color: Color.fromARGB(255, 232, 190, 114))),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showCreateEquipDialog(
                        context,
                        config: EquipConfig(
                          heroId: controller.heroId,
                          equipGroupList: [],
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "创建方案",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedSize(
              itemWidth: 180,
              itemHeight: 240,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: controller.equipConfigFilterList.length,
            itemBuilder: (context, index) {
              var equipConfig = controller.equipConfigFilterList[index];
              return GestureDetector(
                onTap: () {
                  showCreateEquipDialog(context, config: equipConfig);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: EquipConfigItemWidget(
                    controller:
                        EquipConfigItemController(equipConfig: equipConfig),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  void showCreateEquipDialog(
    BuildContext context, {
    required EquipConfig config,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0xff091b20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffe8be72)),
                ),
                child: DeskEquipConfigView(
                  controller: DeskEquipConfigController(equipConfig: config),
                ),
                clipBehavior: Clip.antiAlias,
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xff091b20),
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(color: Color(0xffe8be72)),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Color(0xffe8be72),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) => controller.refresh());
  }
}

class EquipConfigItemController extends MvcController {
  String? heroIcon;
  EquipConfig equipConfig;

  bool get hasHeroIcon => heroIcon != null;

  EquipConfigItemController({
    required this.equipConfig,
  });

  @override
  void onDidUpdateWidget(
      BuildContext context, covariant EquipConfigItemController oldController) {
    super.onDidUpdateWidget(context, oldController);
    heroIcon = oldController.heroIcon;
  }

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  void applyToLolClient(EquipConfig equipConfig) {
    LolApi.instance.putEquipConfig(equipConfig);
  }

  Future<void> fetchData() async {
    heroIcon = (await HeroService.instance.getHeroIcon(equipConfig.heroId));
    notifyListeners();
  }
}

class EquipConfigItemWidget extends MvcView<EquipConfigItemController> {
  const EquipConfigItemWidget({
    super.key,
    required super.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff091b20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffe8be72)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (controller.hasHeroIcon)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset("${controller.heroIcon}"),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: controller.hasHeroIcon ? 4 : 8,
                        vertical: 8),
                    child: Text(
                      "${controller.equipConfig.name ?? "新的装配方案"}",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: 8),
              ),
              SizedBox(
                height: 8,
              ),
              for (var index = 0;
                  index < controller.equipConfig.equipGroupList.length &&
                      index < 3;
                  index++)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    children: [
                      for (var item in controller
                          .equipConfig.equipGroupList[index].equipList)
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: EquipItemWidget(
                            equipInfo: item,
                            iconSize: 36,
                            showLabel: false,
                            dragEnable: false,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 120,
            height: 32,
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 37, 61),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Color.fromARGB(255, 232, 190, 114))),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  controller.applyToLolClient(controller.equipConfig);
                },
                child: const Center(
                  child: Text(
                    "一键应用",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
