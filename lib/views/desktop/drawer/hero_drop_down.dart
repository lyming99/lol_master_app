import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';
import 'package:lol_master_app/util/mvc.dart';

class HeroSelectDropdown extends MvcView<HeroSelectController> {
  final ValueChanged<HeroInfo?>? onChanged;

  const HeroSelectDropdown({
    super.key,
    required super.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.heroList.isEmpty) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xfff6dba6)),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<HeroInfo>(
            value: controller.selectHero,
            iconSize: 16,
            onChanged: (HeroInfo? newValue) {
              controller.setSelectHero(newValue);
              onChanged?.call(newValue);
            },
            items: controller.heroList
                .map<DropdownMenuItem<HeroInfo>>((HeroInfo hero) {
              return DropdownMenuItem<HeroInfo>(
                alignment: Alignment.centerLeft,
                value: hero,
                child: SizedBox(
                  height: 40.0, // 自定义每个菜单项的高度
                  child: Row(
                    children: [
                      SizedBox(
                        child: Image.asset(hero.iconUrl ?? ""),
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8.0),
                      Text(hero.name ?? ""),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class HeroSelectController extends MvcController {
  HeroInfo? selectHero;

  var heroList = <HeroInfo>[];

  void setSelectHero(HeroInfo? newValue) {
    selectHero = newValue;
    notifyListeners();
  }

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, HeroSelectController oldController) {
    super.onDidUpdateWidget(context, oldController);
    selectHero = oldController.selectHero;
    heroList = oldController.heroList;
  }

  Future<void> fetchData() async {
    heroList = await HeroService.instance.getHeroList();
    if (heroList.isNotEmpty) {
      selectHero ??= heroList.first;
    }
    notifyListeners();
  }
}
