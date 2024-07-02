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
    return BrnProgressBarChart(
      barChartStyle: BarChartStyle.vertical,
      xAxis: ChartAxis(axisItemList: [
        AxisItem(showText: '示例1'),
        AxisItem(showText: '示例2'),
        AxisItem(showText: '示例3'),
      ]),
      barBundleList: [
        BrnProgressBarBundle(barList: [
          BrnProgressBarItem(text: '示例21', value: 20,),
          BrnProgressBarItem(
              text: '示例22', value: 15, selectedHintText: '示例12:20'),
          BrnProgressBarItem(
            text: '示例23',
            value: 30,
            selectedHintText:
                '示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30',
          ),
        ], colors: [
          Color(0xff01D57D),
          Color(0xff01D57D)
        ]),
      ],
      yAxis: ChartAxis(axisItemList: [
        AxisItem(showText: '10'),
        AxisItem(showText: '20'),
        AxisItem(showText: '30')
      ]),
      singleBarWidth: 30,
      barGroupSpace: 30,
      barMaxValue: 60,
      onBarItemClickInterceptor:
          (barBundleIndex, barBundle, barGroupIndex, barItem) {
        return true;
      },

    );
  }
}
