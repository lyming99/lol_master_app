import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/util/mvc.dart';

import '../../../controllers/desktop/hero/desk_hero_list_controller.dart';

class DeskHeroListView extends MvcView<DeskHeroListController> {
  const DeskHeroListView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 40),
            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "搜索英雄",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              ),
              style: TextStyle(fontSize: 14),
              onChanged: (value) {
                controller.filterHero();
              },
            ),
          ),
        ),
        Material(
          child: Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Wrap(
              children: [
                for (var i = 0; i < controller.heroGroups.length; i++)
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: InkWell(
                        onTap: () {
                          controller.updateSelectGroup(i);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IgnorePointer(
                                child: Radio(
                                    value: i,
                                    groupValue: controller.selectHeroGroup,
                                    onChanged: (value) {})),
                            Text(controller.heroGroups[i]),
                            SizedBox(width: 8,),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              maxCrossAxisExtent: 120,
            ),
            itemBuilder: (context, index) {
              return _HeroItemWidget(hero: controller.heroFilterList[index]);
            },
            itemCount: controller.heroFilterList.length,
          ),
        ),
      ],
    );
  }
}

class _HeroItemWidget extends StatelessWidget {
  final HeroInfo hero;

  const _HeroItemWidget({required this.hero});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push("/hero/detail", extra: hero);
      },
      child: LayoutBuilder(builder: (context, cons) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              hero.iconUrl ?? "",
              width: cons.maxWidth * 0.6,
              height: cons.maxHeight * 0.6,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              hero.name ?? "",
              style: TextStyle(fontSize: (cons.maxHeight * 0.4 - 4 - 16) / 2),
            ),
          ],
        );
      }),
    );
  }
}
