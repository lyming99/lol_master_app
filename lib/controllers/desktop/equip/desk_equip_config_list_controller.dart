import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/services/equip/equip_service_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskEquipConfigListController extends MvcController {
  var heroId = "";
  var equipConfigList = <EquipConfig>[];
  var equipService = EquipServiceImpl();

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    equipConfigList = await equipService.getEquipConfigList(heroId);
    notifyListeners();
  }

  Future<void> refresh() async {
    return fetchData();
  }

  void applyToLolClient(EquipConfig config) {}
}
