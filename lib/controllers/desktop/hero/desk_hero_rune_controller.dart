import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/rune/rune_service.dart';
import 'package:lol_master_app/services/rune/rune_service_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 英雄符文控制器
class DeskHeroRuneController extends MvcController {
  String? heroId;
  List<RuneConfig> runeConfigList = [];
  List<RuneConfig> runeConfigFilterList = [];
  RuneService runeService = RuneServiceImpl();

  var searchController = TextEditingController();

  DeskHeroRuneController({
    this.heroId,
  });

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    runeConfigList = await runeService.getRuneConfigList(heroId ?? "");
    search(searchController.text);
  }

  Future<void> refresh() async {
    await fetchData();
  }

  Future<void> search(String value) async {
    if (value.isEmpty) {
      runeConfigFilterList = runeConfigList;
    } else {
      runeConfigFilterList = runeConfigList.where((element) {
        return element.configName?.contains(value) == true;
      }).toList();
    }
    notifyListeners();
  }
}
