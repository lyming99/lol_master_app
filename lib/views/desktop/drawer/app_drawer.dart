import 'package:flutter/material.dart';
import 'package:lol_master_app/dao/config/lol_config_dao.dart';
import 'package:lol_master_app/entities/config/lol_config.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/account/lol_account_view.dart';
import 'package:lol_master_app/views/desktop/drawer/hero_drop_down.dart';

class AppDrawerView extends MvcView<AppDrawerController> {
  const AppDrawerView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: LolAccountView(controller: controller.lolAccountController),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 自动接受对局
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 32,
                          color: Color(0xffe8be72),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                            child: Text(
                          "自动接受对局",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffe8be72),
                          ),
                        )),
                        Switch(
                          value: controller.autoAccept,
                          onChanged: (value) {
                            controller.updateAutoAccept(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // 延迟设置
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff4d4d4d),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "延迟: ${controller.autoAcceptDelay.toInt()}秒",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xffe8be72),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Slider(
                              value: controller.autoAcceptDelay,
                              onChanged: (value) {
                                controller.updateAutoAcceptDelay(value);
                              },
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: controller.autoAcceptDelay.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  // 秒选英雄
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.switch_account_outlined,
                          size: 32,
                          color: Color(0xffe8be72),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                            child: Text(
                          "秒选英雄",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffe8be72),
                          ),
                        )),
                        Switch(
                          value: controller.autoSelect,
                          onChanged: (value) {
                            controller.updateAutoSelect(value);
                          },
                        ),
                      ],
                    ),
                  ),
                  // 选择英雄
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xff4d4d4d),
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 36,
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Text(
                                  "首选英雄",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )),
                                SizedBox(
                                  child: HeroSelectDropdown(
                                    controller:
                                        controller.primaryHeroController,
                                    onChanged: (value) {
                                      controller.setPrimarySelectHero(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 36,
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Text(
                                  "次选英雄",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )),
                                SizedBox(
                                  child: HeroSelectDropdown(
                                    controller:
                                        controller.secondaryHeroController,
                                    onChanged: (value) {
                                      controller.setSecondarySelectHero(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 36,
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Text(
                                  "备选英雄",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )),
                                SizedBox(
                                  child: HeroSelectDropdown(
                                    controller: controller.thirdHeroController,
                                    onChanged: (value) {
                                      controller.setThirdSelectHero(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        "本软件未获得 Riot Games 的认可，也不反映 Riot Games 或任何正式参与制作或管理 Riot Games 财产的人的观点或意见。"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AppDrawerController extends MvcController {
  var heroList = <HeroInfo>[];

  var primaryHeroController = HeroSelectController();

  var secondaryHeroController = HeroSelectController();

  var thirdHeroController = HeroSelectController();

  var lolAccountController = LolAccountController();

  LolConfig? lolConfig;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, AppDrawerController oldController) {
    super.onDidUpdateWidget(context, oldController);
    heroList = oldController.heroList;
    primaryHeroController = oldController.primaryHeroController;
    secondaryHeroController = oldController.secondaryHeroController;
    thirdHeroController = oldController.thirdHeroController;
    lolAccountController = oldController.lolAccountController;
    lolConfig = oldController.lolConfig;
  }

  Future<void> fetchData() async {
    heroList = await HeroService.instance.getHeroList();
    lolConfig =
        (await LolConfigService.instance.getCurrentConfig()) ?? LolConfig();
    var primaryInfo = await HeroService.instance
        .getHeroInfo(lolConfig?.primaryHero.toString() ?? "0");
    primaryHeroController.setSelectHero(primaryInfo);
    var secondaryInfo = await HeroService.instance
        .getHeroInfo(lolConfig?.secondaryHero.toString() ?? "0");
    secondaryHeroController.setSelectHero(secondaryInfo);
    var thirdInfo = await HeroService.instance
        .getHeroInfo(lolConfig?.thirdHero.toString() ?? "0");
    thirdHeroController.setSelectHero(thirdInfo);
    notifyListeners();
  }

  bool get autoSelect => lolConfig?.autoSelect == true;

  bool get autoAccept => lolConfig?.autoAccept == true;

  double get autoAcceptDelay => (lolConfig?.autoAcceptDelay ?? 0).toDouble();

  void updateAutoAccept(bool value) {
    lolConfig?.autoAccept = value;
    saveConfig();
  }

  void updateAutoSelect(bool value) {
    lolConfig?.autoSelect = value;
    saveConfig();
  }

  void setPrimarySelectHero(HeroInfo? item) {
    lolConfig?.primaryHero = int.parse(item?.heroId ?? "0");
    saveConfig();
  }

  void setSecondarySelectHero(HeroInfo? item) {
    lolConfig?.secondaryHero = int.parse(item?.heroId ?? "0");
    saveConfig();
  }

  void setThirdSelectHero(HeroInfo? item) {
    lolConfig?.thirdHero = int.parse(item?.heroId ?? "0");
    saveConfig();
  }

  void updateAutoAcceptDelay(double value) {
    lolConfig?.autoAcceptDelay = value.toInt();
    saveConfig();
  }

  Future<void> saveConfig() async {
    await LolConfigService.instance.updateCurrentConfig(lolConfig);
    notifyListeners();
  }
}
