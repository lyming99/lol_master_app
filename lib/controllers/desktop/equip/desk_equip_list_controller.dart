import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskEquipListController extends MvcController {
  var equipList = <EquipInfo>[];

  var equipFilterList = <EquipInfo>[];

  var searchController = TextEditingController();

  var typeSet = <dynamic>{};

  var filterTypeSet = <dynamic>{};

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<Map> readLanguage() async {
    var lan = await rootBundle.loadString("assets/lol/data/language.json");
    return jsonDecode(lan)["data"];
  }

  Future<void> fetchData() async {
    var resp = await Dio()
        .get("https://game.gtimg.cn/images/lol/act/img/js/items/items.js");
    if (resp.statusCode != 200) {
      return;
    }
    var langMap = await readLanguage();
    var data = resp.data;
    var items = jsonDecode(data)["items"] as List;
    equipList = [];
    for (var item in items) {
      //{
      //     "itemId": "1001",
      //     "name": "鞋子",
      //     "iconPath": "https://game.gtimg.cn/images/lol/act/img/item/1001.png",
      //     "price": "300",
      //     "description": "<mainText><stats><attention>25</attention>移动速度</stats><br><br></mainText>",
      //     "maps": [
      //         "嚎哭深渊",
      //         "召唤师峡谷"
      //     ],
      //     "plaintext": "略微提升移动速度",
      //     "sell": "210",
      //     "total": "300",
      //     "into": [
      //         "3005",
      //         "3006",
      //         "3009",
      //         "3010",
      //         "3020",
      //         "3047",
      //         "3111",
      //         "3117",
      //         "3158"
      //     ],
      //     "from": "",
      //     "suitHeroId": "",
      //     "tag": "",
      //     "types": [
      //         "Boots"
      //     ],
      //     "keywords": "鞋,鞋子,速度之靴,xz,x,xie,xiezi,suduzhixue"
      // }
      var equipInfo = EquipInfo(
        itemId: item["itemId"],
        name: item["name"],
        icon: item["iconPath"],
        desc: item["description"],
        keywords: item["keywords"],
        price: item["total"],
        sell: item["sell"],
        types: item["types"]?.map((item) => langMap[item] ?? item).join(","),
      );
      equipList.add(equipInfo);
      typeSet.addAll(item["types"]
          ?.where((item) => langMap[item] != null)
          .map((item) => (langMap[item] ?? item).toString())
          .toList());
    }
    print(typeSet.join(","));
    filterEquip();
  }

  Future<void> filterEquip() async {
    equipFilterList = equipList
        .where((element) =>
            true == element.keywords?.contains(searchController.text))
        .toList();
    notifyListeners();
  }

  void searchEquip(String value, Set<String> filters) {
    equipFilterList = equipList.where((element) {
      return true == element.keywords?.contains(value) && (filters.isEmpty ||
          filters.every((item) => element.types?.contains(item) ?? false));
    }).toList();
    notifyListeners();
  }
}
