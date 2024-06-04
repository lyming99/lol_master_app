import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/hero/hero_spell.dart';
import 'package:lol_master_app/services/api/hero_api_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 英雄技能控制器
class DeskHeroSpellController extends MvcController {
  List<HeroSpell> spells = [];
  int selectSkillIndex = 0;
  String? heroId;

  HeroSpell? selectedSpell;

  DeskHeroSpellController({
    this.heroId,
  });

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    spells = [];
    var heroSpells = await HeroApiImpl().queryHeroSpells(heroId ?? "");
    if (heroSpells != null) {
      spells = heroSpells;
    }
    selectSkill(0);
  }

  void selectSkill(int index) {
    selectSkillIndex = index;
    if (index < spells.length) {
      selectedSpell = spells[index];
    } else {
      selectedSpell = null;
    }
    notifyListeners();
  }
}
