import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_combo_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 英雄连招视图
class DeskHeroComboView extends MvcView<DeskHeroComboController> {
  const DeskHeroComboView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Text("连招技巧");
  }
}
