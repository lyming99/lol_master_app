import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';

/// 相关性排行统计图
/// 胜利相关性
/// 失败相关性
class CorrelationStatisticGraphx extends StatelessWidget {
  final DeskStatisticController controller;

  const CorrelationStatisticGraphx({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    var list = controller.failTopList;
    return BrnProgressBarChart(
      barChartStyle: BarChartStyle.vertical,
      xAxis: ChartAxis(axisItemList: [
        for (var i = 0; i < list.length && i < 8; i++)
          AxisItem(showText: list[i].itemName ?? ""),
      ]),
      barBundleList: [
        BrnProgressBarBundle(
          barList: [
            for (var i = 0; i < list.length && i < 8; i++)
              BrnProgressBarItem(
                text: list[i].getMaxValueName(false),
                value: list[i].failRate * 100,
                selectedHintText: list[i].getHintText(false),
              ),
          ],
          colors: [
            Color(0xff01D57D),
            Color(0xff01D57D),
          ],
        ),
      ],
      yAxis: ChartAxis(
          axisItemList: [AxisItem(showText: '50'), AxisItem(showText: '100')]),
      singleBarWidth: 10,
      barGroupSpace: 50,
      barMaxValue: 100,
      onBarItemClickInterceptor:
          (barBundleIndex, barBundle, barGroupIndex, barItem) {
        return true;
      },
    );
  }
}
