import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';
import 'package:lol_master_app/services/hero/hero_service_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskHeroListController extends MvcController {
  HeroService heroService = HeroServiceImpl();

  List<HeroInfo> heroList = [];

  List<HeroInfo> heroFilterList = [];

  int selectHeroGroup = 0;

  var heroGroups = ["所有英雄", "上路", "中路", "打野", "下路", "辅助"];

  var searchController = TextEditingController();

  void searchHero(String value) {}

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    heroList = await heroService.getHeroList();
    await filterHero();
  }

  Future<void> filterHero() async {
    heroFilterList = heroList.where((element) {
      // if (selectHeroGroup == heroGroups.length - 1) {
      //   return element.favorite == true;
      // }
      if (selectHeroGroup == 0) {
        return true;
      }
      return element.roadType?.contains(heroGroups[selectHeroGroup]) ?? false;
    }).where((element) {
      if (searchController.text == "") {
        return true;
      }
      return element.name?.contains(searchController.text) == true ||
          element.nickname?.contains(searchController.text) == true ||
          element.searchKey?.contains(searchController.text) == true;
    }).toList();
    notifyListeners();
  }

  void updateSelectGroup(int index) {
    selectHeroGroup = index;
    filterHero();
  }
}
