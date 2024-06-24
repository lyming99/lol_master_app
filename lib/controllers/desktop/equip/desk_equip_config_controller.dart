import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:lol_master_app/controllers/desktop/equip/desk_equip_list_controller.dart';
import 'package:lol_master_app/dao/equip/equip_dao.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskEquipConfigController extends MvcController {
  var equipDao = EquipDao.instance;

  var isShowRenameEdit = false;

  var isShowEquipTree = false;

  EquipInfo? selectedEquipInfo;

  var nameEditFocusNode = FocusNode();

  var nameEditController = TextEditingController();

  var searchEditController = TextEditingController();

  var filters = <FilterItem>[];

  var equipListController = DeskEquipListController();

  EquipConfig equipConfig;

  DeskEquipConfigController({
    required this.equipConfig,
  });

  int get equipGroupCount => equipConfig.equipGroupList.length;

  String get equipName => equipConfig.name == null || equipConfig.name == ""
      ? "新的装配方案"
      : equipConfig.name!;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    nameEditFocusNode.addListener(() {
      if (!nameEditFocusNode.hasFocus) {
        setShowRenameEdit(false);
      }
    });
    fetchData();
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, covariant DeskEquipConfigController oldController) {
    super.onDidUpdateWidget(context, oldController);
    isShowRenameEdit = oldController.isShowRenameEdit;
    isShowEquipTree = oldController.isShowEquipTree;
    nameEditController = oldController.nameEditController;
    searchEditController = oldController.searchEditController;
    filters = oldController.filters;
    equipListController = oldController.equipListController;
  }

  Future<void> fetchData() async {
    nameEditController.text = equipName;
    filters =
        "攻击力,暴击,法术强度,攻击速度,护甲穿透,冷却缩减,鞋子,其它移动速度物品,护甲,魔法抗性,法力值,法力回复,法术吸血,法术穿透,生命回复,生命值,生命偷取,消耗品,韧性,光环,减速,工资装"
            .split(",")
            .map((e) => FilterItem(name: e, isChecked: false))
            .toList();
    notifyListeners();
  }

  void setShowRenameEdit(bool value) {
    isShowRenameEdit = value;
    notifyListeners();
    if (value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        nameEditFocusNode.requestFocus();
      });
    }
  }

  void updateName(String value) {
    equipConfig.name = value;
  }

  Future<void> saveConfig() async {
    if (equipConfig.name == null || equipConfig.name == "") {
      equipConfig.name = "新的装配方案";
    }
    if (equipConfig.id == null || equipConfig.id == -1) {
      await equipDao.addEquipConfig(equipConfig);
    } else {
      await equipDao.updateEquipConfig(equipConfig);
    }
  }

  void deleteConfig() {
    equipDao.deleteEquipConfig(equipConfig);
  }

  void clearFilter() {
    filters.forEach((element) {
      element.isChecked = false;
    });
    notifyListeners();
    search(searchEditController.text);
  }

  void updateFilterChecked(FilterItem filter, bool value) {
    filter.isChecked = value;
    notifyListeners();
    search(searchEditController.text);
  }

  void search(String value) {
    equipListController.searchEquip(
        value,
        filters
            .where((element) => element.isChecked)
            .map((e) => e.name)
            .toSet());
  }

  EquipGroup getEquipGroup(int index) {
    return equipConfig.equipGroupList[index];
  }

  void addEquipGroup(EquipInfo data) {
    for (var group in equipConfig.equipGroupList) {
      group.equipList.remove(data);
    }
    equipConfig.equipGroupList.add(EquipGroup(
      name: "新的区块",
      equipList: [data.copyWith()],
    ));
    notifyListeners();
  }

  void addEquipInfo(EquipGroup equipGroup, EquipInfo equipInfo, int index) {
    index = min(index, equipGroup.equipList.length);
    if (equipGroup.equipList.contains(equipInfo)) {
      //调节位置
      var oldIndex = equipGroup.equipList.indexOf(equipInfo);
      if (index > oldIndex) {
        index--;
      }
      equipGroup.equipList.removeAt(oldIndex);
      equipGroup.equipList.insert(index, equipInfo.copyWith());
    } else {
      //直接插入
      // 1.移除
      for (var value in equipConfig.equipGroupList) {
        if (value == equipGroup) {
          continue;
        }
        value.equipList.remove(equipInfo);
      }
      // 2.插入
      equipGroup.equipList.insert(index, equipInfo.copyWith());
    }
    notifyListeners();
  }

  double calculateEquipGroupHeight(double maxWidth) {
    int crossAxiCount = 1;
    for (var i = 1;; i++) {
      if (48 * i + (10 * (i + 1)) > maxWidth) {
        break;
      }
      crossAxiCount = i;
    }
    double ret = 0;
    for (var equipGroup in equipConfig.equipGroupList) {
      var count = equipGroup.equipList.length;
      var rowCount = (count / crossAxiCount).ceil();
      if (rowCount == 0) {
        rowCount = 1;
      }
      var contentHeight = rowCount * 68 + (rowCount - 1) * 10;
      // 标题栏
      contentHeight += 40;
      // 内边距
      contentHeight += 40;
      ret += contentHeight;
    }
    return ret + 10;
  }

  int getColCount(double width) {
    int crossAxiCount = 1;
    for (var i = 1;; i++) {
      if (48 * i + (10 * (i + 1)) > width) {
        break;
      }
      crossAxiCount = i;
    }
    return crossAxiCount;
  }

  void setShowEquipTree(bool val) {
    isShowEquipTree = val;
    notifyListeners();
  }

  void showEquipTree(EquipInfo info) {
    setShowEquipTree(true);
    selectedEquipInfo = info;
  }

  void removeEquipGroup(EquipGroup equipGroup) {
    equipConfig.equipGroupList.remove(equipGroup);
    notifyListeners();
  }

  void moveGroupUp(EquipGroup equipGroup) {
    var index = equipConfig.equipGroupList.indexOf(equipGroup);
    var temp = equipConfig.equipGroupList[index - 1];
    equipConfig.equipGroupList[index - 1] = equipConfig.equipGroupList[index];
    equipConfig.equipGroupList[index] = temp;
    notifyListeners();
  }

  void moveGroupDown(EquipGroup equipGroup) {
    var index = equipConfig.equipGroupList.indexOf(equipGroup);
    var temp = equipConfig.equipGroupList[index + 1];
    equipConfig.equipGroupList[index + 1] = equipConfig.equipGroupList[index];
    equipConfig.equipGroupList[index] = temp;
    notifyListeners();
  }
}

class FilterItem {
  String name;
  bool isChecked;

  FilterItem({required this.name, required this.isChecked});
}
