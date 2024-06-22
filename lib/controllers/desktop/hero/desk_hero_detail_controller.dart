import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_config_list_controller.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_base_attr_controller.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_combo_controller.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_equip_controller.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_note_controller.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_spell_controller.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_rune_controller.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/equip/desk_equip_config_list_view.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_base_attr_view.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_equip_view.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_note_view.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_spell_view.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_rune_view.dart';

class DeskHeroDetailController extends MvcController {
  HeroInfo? hero;
  TabController? tabController;

  // 数值
  DeskHeroBaseAttrController heroBaseAttrController =
      DeskHeroBaseAttrController();

  // 技能
  DeskHeroSpellController heroSpellController = DeskHeroSpellController();

  // 符文
  DeskHeroRuneController heroRuneController = DeskHeroRuneController();

  // 出装
  DeskEquipConfigListController heroEquipController =
      DeskEquipConfigListController();

  // 思路
  DeskHeroNoteController heroNoteController = DeskHeroNoteController();

  // 连招
  DeskHeroComboController heroComboController = DeskHeroComboController();

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    tabController = TabController(length: tabTitles.length, vsync: state);
    heroSpellController.heroId = hero?.heroId;
    heroEquipController.heroId = hero?.heroId??"";
  }

  List<String> get tabTitles => ["技能", "属性", "符文", "装备", "攻略"];

  List<Widget> get tabViews {
    return [
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DeskHeroSpellView(controller: heroSpellController),
      ),
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DeskHeroBaseAttrView(controller: heroBaseAttrController),
      ),
      DeskHeroRuneView(controller: heroRuneController),
      DeskEquipConfigListView(controller: heroEquipController),
      DeskHeroNoteView(controller: heroNoteController),
    ];
  }
}
