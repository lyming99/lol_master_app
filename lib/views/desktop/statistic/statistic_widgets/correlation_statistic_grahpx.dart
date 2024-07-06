import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

class CorrelationStatisticGraphxController extends MvcController {
  var dataList = <ChildItemWinRate>[];
  var isWinMode = true;
  int? hoverGroupIndex;

  void setData(List<ChildItemWinRate> dataList, bool winMode) {
    this.dataList = dataList;
    isWinMode = winMode;
    notifyListeners();
  }

  double getRate(int i) {
    if (isWinMode) {
      return dataList[i].winRate;
    }
    return dataList[i].failRate;
  }

  void updateHoverGroupIndex(int? groupIndex) {
    hoverGroupIndex = groupIndex;
    notifyListeners();
  }
}

/// 相关性排行统计图
/// 胜利相关性
/// 失败相关性
class CorrelationStatisticGraphx
    extends MvcView<CorrelationStatisticGraphxController> {
  const CorrelationStatisticGraphx({
    super.key,
    required super.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: max(cons.maxWidth, controller.dataList.length * 80),
          padding: const EdgeInsets.all(8),
          child: MouseRegion(
            cursor: controller.hoverGroupIndex == null
                ? MouseCursor.defer
                : SystemMouseCursors.click,
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGroups,
                gridData: const FlGridData(show: true),
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
              ),
            ),
          ),
        ),
      );
    });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchCallback: (event, response) {
          event.localPosition;
          // response.spot;
          var groupIndex = response?.spot?.touchedBarGroupIndex;
          controller.updateHoverGroupIndex(groupIndex);
        },
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => const Color(0xff102730),
          tooltipPadding: EdgeInsets.all(8),
          maxContentWidth: 200,
          tooltipMargin: 8,
          tooltipHorizontalAlignment: FLHorizontalAlignment.center,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipBorder: BorderSide(color: Color(0xfff6dba6)),
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            if (groupIndex != controller.hoverGroupIndex) {
              return null;
            }
            return BarTooltipItem(
              "",
              children: [
                controller.dataList[groupIndex]
                    .getHintText(controller.isWinMode),
              ],
              textAlign: TextAlign.start,
              const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.grey,
      fontSize: 14,
    );
    String text = controller.dataList[value.toInt()].itemName ?? "";
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Container(
        width: 80,
        alignment: Alignment.center,
        child: Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          if(controller.isWinMode)Colors.green,
          if(controller.isWinMode) Colors.green,
          if(!controller.isWinMode)Colors.red,
          if(!controller.isWinMode) Colors.red,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        for (var i = 0; i < controller.dataList.length; i++)
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: controller.getRate(i),
                gradient: _barsGradient,
                width: 20,
                borderRadius: BorderRadius.zero,
              )
            ],
            showingTooltipIndicators: [0],
            barsSpace: 20,
          ),
      ];
}
