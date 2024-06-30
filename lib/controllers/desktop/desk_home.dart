import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_list_controller.dart';
import 'package:lol_master_app/controllers/desktop/spell/desk_spell_list_controller.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/controllers/desktop/summoner/match_history_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/account/lol_account_view.dart';
import 'package:lol_master_app/views/desktop/drawer/app_drawer.dart';
import 'package:lol_master_app/views/desktop/game_info/desk_game_info_view.dart';

import 'equip/desk_equip_config_list_controller.dart';
import 'hero/desk_hero_list_controller.dart';

class DeskHomeController extends MvcController {
  TabController? tabController;

  DeskHeroListController heroListController = DeskHeroListController();

  DeskEquipConfigListController itemListController =
      DeskEquipConfigListController();

  DeskSpellListController spellListController = DeskSpellListController();

  DeskRuneListController runeListController = DeskRuneListController();

  var lolAccountIconController = LolAccountIconController();

  var appDrawerController = AppDrawerController();

  var matchHistoryController = DeskMatchHistoryController();

  var gameInfoController = DeskGameInfoController();

  var statisticController = DeskStatisticController();

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    tabController = TabController(length: 6, vsync: state);
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, covariant DeskHomeController oldController) {
    super.onDidUpdateWidget(context, oldController);
    tabController = oldController.tabController;
    heroListController = oldController.heroListController;
    lolAccountIconController = oldController.lolAccountIconController;
    appDrawerController = oldController.appDrawerController;
    itemListController = oldController.itemListController;
    spellListController = oldController.spellListController;
    runeListController = oldController.runeListController;
    gameInfoController = oldController.gameInfoController;
    statisticController = oldController.statisticController;
  }
}
