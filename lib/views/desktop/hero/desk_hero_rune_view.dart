import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_config_controller.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/desktop/rune/desk_rune_config_view.dart';
import 'package:lol_master_app/views/desktop/rune/rune_item_widget.dart';
import 'package:lol_master_app/widgets/grid_view_fix_size.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_rune_controller.dart';

/// 英雄符文视图
class DeskHeroRuneView extends MvcView<DeskHeroRuneController> {
  const DeskHeroRuneView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: Row(
            children: [
              //搜索符文
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "搜索符文",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    ),
                    controller: controller.searchController,
                    onChanged: (value){
                      controller.search(value);
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 30, 37, 61),
                    borderRadius: BorderRadius.circular(4),
                    border:
                        Border.all(color: Color.fromARGB(255, 232, 190, 114))),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showCreateRuneDialog(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "创建符文",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedSize(
              itemWidth: 120,
              itemHeight: 250,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: controller.runeConfigFilterList.length,
            itemBuilder: (context, index) {
              var runeConfig = controller.runeConfigFilterList[index];
              return GestureDetector(
                onTap: () {
                  showCreateRuneDialog(context, config: runeConfig);
                },
                child: RuneItemWidget(
                  controller: RuneItemController(runeConfig: runeConfig),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  void showCreateRuneDialog(BuildContext context, {RuneConfig? config}) {
    var heroId = controller.heroId;
    showDialog(
      context: context,
      builder: (context) {
        // 计算窗口大小
        // cWidth = pWidth+60+30
        // cHeight = pHeight+60+30
        // pHeight = pWidth*720/1162
        // cWidth==wWidth-90||cHeight==wHeight-90
        var wWidth = MediaQuery.of(context).size.width;
        var wHeight = MediaQuery.of(context).size.height;
        var cWidth = wWidth - 90;
        var cHeight = wHeight - 90;
        var pWidth = wWidth - 60;
        var pHeight = wHeight - 60;
        if (cHeight > 0 && (cWidth / cHeight > 1162 / 720)) {
          pWidth = (cHeight * 1162 / 720) + 30;
        } else {
          pHeight = (cWidth * 720 / 1162) + 30;
        }
        if (pWidth > 1162 + 30) {
          pWidth = 1162 + 30;
        }
        if (pHeight > 720 + 30) {
          pHeight = 720 + 30;
        }
        return Center(
          child: Container(
            width: pWidth,
            height: pHeight,
            margin: EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 20),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  child: AspectRatio(
                    aspectRatio: 1162 / 720,
                    child: DeskRuneConfigView(
                      controller: DeskRuneConfigController(
                        config: config ?? RuneConfig(heroId: heroId),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 89, 61, 61),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    ).then((value) => controller.refresh());
  }
}
