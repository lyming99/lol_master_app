import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/views/widgets/rune/rune_background_widget.dart';
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
                    decoration: InputDecoration(
                      hintText: "搜索符文",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              // 创建符文
              Ink(
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            gridDelegate: SliverGridDelegateWithFixedSize(
              itemWidth: 160,
              itemHeight: 240,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: 10,
            itemBuilder: (context, index) {
              return RuneBackgroundWidget(
                name: "Domination",
                runeClip:
                    RuneClip(left: 0.55, top: 0.22, right: 0.8, bottom: 0.88),
              );
            },
          ),
        )
      ],
    );
  }
}
