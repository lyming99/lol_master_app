import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/equip/equip_info.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 英雄装备控制器
class DeskHeroEquipController extends MvcController {
  var equipList = <EquipConfig>[
    EquipConfig(
      name: "剑圣打野出装",
      icon:
          "https://game.gtimg.cn/images/lol/act/img/equipment/equipment_1.png",
      startEquipList: [
        EquipInfo(
          icon: "assets/lol/img/item/1001.png",
        ),
        EquipInfo(
          icon: "assets/lol/img/item/1001.png",
        ),
        EquipInfo(
          icon: "assets/lol/img/item/1001.png",
        ),
      ],
    ),
    EquipConfig(
      name: "剑圣打野出装",
      icon:
          "https://game.gtimg.cn/images/lol/act/img/equipment/equipment_1.png",
      startEquipList: [
        EquipInfo(
          icon: "assets/lol/img/item/1001.png",
        ),
        EquipInfo(
          icon: "assets/lol/img/item/1001.png",
        ),
      ],
    ),
  ];
}
