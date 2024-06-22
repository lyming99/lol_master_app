import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_list_controller.dart';
import 'package:lol_master_app/controllers/desktop/spell/desk_spell_list_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

import 'equip/desk_equip_config_list_controller.dart';
import 'hero/desk_hero_list_controller.dart';

class DeskHomeController extends MvcController {
  TabController? tabController;

  DeskHeroListController heroListController = DeskHeroListController();

  DeskEquipConfigListController itemListController =
      DeskEquipConfigListController();

  DeskSpellListController spellListController = DeskSpellListController();

  DeskRuneListController runeListController = DeskRuneListController();

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    tabController = TabController(length: 3, vsync: state);
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, covariant DeskHomeController oldController) {
    super.onDidUpdateWidget(context, oldController);
    tabController = oldController.tabController;
    heroListController = oldController.heroListController;
  }
}
