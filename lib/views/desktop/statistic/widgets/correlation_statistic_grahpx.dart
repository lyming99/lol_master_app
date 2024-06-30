
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';

/// 相关性排行统计图
/// 胜利相关性
/// 失败相关性
class CorrelationStatisticGraphx extends StatelessWidget {
  final DeskStatisticController controller;

  const CorrelationStatisticGraphx({super.key,
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
        AxisItem(showText: '示例4'),
        AxisItem(showText: '示例5'),
        AxisItem(showText: '示例6'),
        AxisItem(showText: '示例7'),
        AxisItem(showText: '示例8'),
        AxisItem(showText: '示例9'),
        AxisItem(showText: '示例10'),
      ]),
      barBundleList: [
        BrnProgressBarBundle(barList: [
          BrnProgressBarItem(
              text: '示例11',
              value: 5,
              hintValue: 15,
              showBarValueText: "1122334"),
          BrnProgressBarItem(
              text: '示例12', value: 20, selectedHintText: '示例12:20'),
          BrnProgressBarItem(
              text: '示例13',
              value: 30,
              selectedHintText:
              '示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30'),
          BrnProgressBarItem(text: '示例14', value: 25),
          BrnProgressBarItem(text: '示例15', value: 21),
          BrnProgressBarItem(text: '示例16', value: 28),
          BrnProgressBarItem(text: '示例17', value: 15),
          BrnProgressBarItem(text: '示例18', value: 11),
          BrnProgressBarItem(text: '示例19', value: 30),
          BrnProgressBarItem(text: '示例110', value: 24),
        ], colors: [
          Color(0xff1545FD),
          Color(0xff0984F9)
        ]),
        BrnProgressBarBundle(barList: [
          BrnProgressBarItem(text: '示例21', value: 20, hintValue: 15),
          BrnProgressBarItem(
              text: '示例22', value: 15, selectedHintText: '示例12:20'),
          BrnProgressBarItem(
              text: '示例23',
              value: 30,
              selectedHintText:
              '示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30\n示例13:30'),
          BrnProgressBarItem(text: '示例24', value: 20),
          BrnProgressBarItem(text: '示例25', value: 28),
          BrnProgressBarItem(text: '示例26', value: 25),
          BrnProgressBarItem(text: '示例27', value: 17),
          BrnProgressBarItem(text: '示例28', value: 14),
          BrnProgressBarItem(text: '示例29', value: 36),
          BrnProgressBarItem(text: '示例210', value: 29),
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