import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/equip/equip_service.dart';
import 'package:lol_master_app/services/equip/equip_service_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskEquipConfigListController extends MvcController {
  var heroId = "";
  var equipConfigList = <EquipConfig>[];
  var equipService = EquipServiceImpl();
  var equipConfigFilterList = <EquipConfig>[];

  var searchController = TextEditingController();

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    equipConfigList = await equipService.getEquipConfigList(heroId);
    search(searchController.text);
  }

  Future<void> refresh() async {
    return fetchData();
  }

  Future<void> applyToLolClient(EquipConfig config) async {
    await LolApi.instance.putEquipConfig(config);
  }

  Future<void> search(String value) async {
    if (value.isEmpty) {
      equipConfigFilterList = equipConfigList;
      notifyListeners();
      return;
    }
    equipConfigFilterList = equipConfigList.where((element) {
      return element.name!.contains(value);
    }).toList();
    notifyListeners();
  }
}
