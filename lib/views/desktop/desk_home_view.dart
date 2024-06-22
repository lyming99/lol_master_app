import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/rune/desk_rune_list_view.dart';
import 'package:lol_master_app/views/desktop/spell/desk_spell_list_view.dart';
import 'package:window_manager/window_manager.dart';

import '../../controllers/desktop/desk_home.dart';
import 'equip/desk_equip_config_list_view.dart';
import 'hero/desk_hero_list_view.dart';

class DeskHomeView extends MvcView<DeskHomeController> {
  const DeskHomeView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        title: DragToMoveArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 56,
            child: const Text("LOL大师助手"),
          ),
        ),
      ),
      drawer: Container(
        width: 400,
        color: Colors.white,
      ),
      body: Column(
        children: [
          Material(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerHeight: 0.1,
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.symmetric(vertical: 0),
                tabs: const [
                  Tab(
                    text: "英雄",
                    height: 32,
                  ),
                  Tab(
                    text: "符文",
                    height: 32,
                  ),
                  Tab(
                    text: "装备",
                    height: 32,
                  ),
                ],
                controller: controller.tabController,
              ),
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: controller.tabController,
            children: [
              DeskHeroListView(
                controller: controller.heroListController,
              ),
              DeskRuneListView(
                controller: controller.runeListController,
              ),
              DeskEquipConfigListView(
                controller: controller.itemListController,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
