import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';

import 'correlation_statistic_grahpx.dart';
import 'standard_statistic_graphx.dart';

class StatisticView extends StatelessWidget {
  final DeskStatisticController controller;

  const StatisticView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.all(8),
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
                Text("相关性排行统计图"),
                Expanded(
                    child: CorrelationStatisticGraphx(
                  controller: controller,
                )),
              ],
            ),
          )),
          Expanded(
              child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xfff6dba6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("标准项目统计图"),
                Expanded(
                    child: StandardStatisticGraphx(
                  controller: controller,
                )),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
