import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_list_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

import '../hero/desk_hero_rune_view.dart';

class DeskRuneListView extends MvcView<DeskRuneListController> {
  const DeskRuneListView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return DeskHeroRuneView(controller: controller.heroRuneController);
  }
}
