import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/widgets/dropmenu/drop_menu.dart';

import 'correlation_statistic_grahpx.dart';

class StatisticView extends StatelessWidget {
  final DeskStatisticController controller;

  const StatisticView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xfff6dba6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("相关性统计"),
                      Spacer(),
                      MyDropDownMenu(
                        controller: controller.winModeController,
                        itemBuilder: (context, index) {
                          var item = controller.winModeController.items[index];
                          return Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.centerLeft,
                              height: 32,
                              child: Text(item));
                        },
                        onItemSelected: (index) {
                          controller.updateWinMode(index);
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: CorrelationStatisticGraphx(
                  controller: controller.correlationController,
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
