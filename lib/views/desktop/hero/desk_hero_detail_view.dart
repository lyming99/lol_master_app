import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_detail_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:window_manager/window_manager.dart';

class DeskHeroDetailView extends MvcView<DeskHeroDetailController> {
  const DeskHeroDetailView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: DragToMoveArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 56,
            child: Text(controller.hero?.name ?? ""),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              dividerHeight: 0.1,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: const EdgeInsets.symmetric(vertical: 0),
              tabs: [
                for (var title in controller.tabTitles)
                  Tab(
                    text: title,
                    height: 32,
                  ),
              ],
              controller: controller.tabController,
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: controller.tabController,
            children: controller.tabViews,
          )),
        ],
      ),
    );
  }
}
