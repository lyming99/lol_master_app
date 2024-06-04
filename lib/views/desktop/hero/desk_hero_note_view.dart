import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_note_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 英雄思路笔记视图
class DeskHeroNoteView extends MvcView<DeskHeroNoteController> {
  const DeskHeroNoteView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Text("思路");
  }
}
