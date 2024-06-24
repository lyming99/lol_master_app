import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/drawer/app_drawer.dart';
import 'package:lol_master_app/views/desktop/rune/desk_rune_list_view.dart';
import 'package:window_manager/window_manager.dart';

import '../../controllers/desktop/desk_home.dart';
import '../../services/api/lol_api.dart';
import 'account/lol_account_view.dart';
import 'equip/desk_equip_config_list_view.dart';
import 'hero/desk_hero_list_view.dart';

class DeskHomeView extends MvcView<DeskHomeController> {
  const DeskHomeView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: LolAccountIconView(
              emptyIcon: const Icon(Icons.menu),
              controller: controller.lolAccountIconController,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        backgroundColor: Colors.transparent,
        title: DragToMoveArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 56,
            child: ValueListenableBuilder(
              valueListenable: LolApi.instance.state,
              builder: (BuildContext context, bool value, Widget? child) {
                var gameName = LolApi.instance.getAccountInfo()?.gameName;
                return Text(gameName ?? "LOL大师助手");
              },
            ),
          ),
        ),
      ),
      drawer: SizedBox(
        width: 340,
        child: AppDrawerView(controller: controller.appDrawerController),
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
