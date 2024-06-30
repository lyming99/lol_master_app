
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';

/// 标准项目统计图
/// 采用折线图
///
class StandardStatisticGraphx extends StatelessWidget {
  final DeskStatisticController controller;

  const StandardStatisticGraphx({super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _brokenLineDemo3(context);
  }

  Widget _brokenLineDemo3(context) {
    var chartLine = BrnBrokenLine(
      showPointDashLine: false,
      yHintLineOffset: 40,
      lines: _getPointsLinesForDemo3(),
      size: Size(MediaQuery.of(context).size.width - 50 * 2,
          MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
      isShowXHintLine: true,
      yDialValues: getYDialValuesForDemo3(),
      xDialValues: _getXDialValuesForDemo3(_getPointsLinesForDemo3()),
      yDialMin: 0,
      yDialMax: 120,
      xDialMin: 1,
      xDialMax: 11,
      isHintLineSolid: false,
      isShowYDialText: true,
    );
    return Container(
      child: Column(
        children: <Widget>[
          // _buildIdentificationList(),
          SizedBox(
            height: 16,
          ),
          chartLine,
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  List<BrnPointsLine> _getPointsLinesForDemo3() {
    BrnPointsLine pointsLine, _pointsLine2;
    List<BrnPointsLine> pointsLineList = [];
    pointsLine = BrnPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: true,
      isCurve: false,
      points: [
        BrnPointData(
            pointText: '30',
            y: 30,
            x: 1,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return Container(
                    alignment: Alignment.center,
                    width: 40,
                    height: 40,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 30,
                            color: Colors.orange,
                          ),
                          Container(
                            height: 30,
                            color: Colors.greenAccent,
                          ),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.green),
                          Container(height: 20, color: Colors.blue)
                        ],
                      ),
                    ),
                  );
                })),
        BrnPointData(
          pointText: '88',
          y: 80,
          x: 2,
          lineTouchData: BrnLineTouchData(
            onTouch: () {
              return Container(
                padding:
                EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                child: Center(
                    child: Text(
                      'content',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0.0, 2.0), //阴影xy轴偏移量
                      blurRadius: 4.0, //阴影模糊程度
                    )
                  ],
                ),
              );
            },
            tipWindowSize: Size(60, 40),
          ),
        ),
        BrnPointData(
            pointText: '20',
            y: 20,
            x: 3,
            lineTouchData: BrnLineTouchData(
                onTouch: () {
                  return '20';
                },
                tipWindowSize: Size(60, 40))),
        BrnPointData(
            pointText: '67',
            y: 67,
            x: 4,
            lineTouchData: BrnLineTouchData(onTouch: () {
              return '66';
            }, tipWindowSize: Size(60, 40))),
        BrnPointData(
            pointText: '10',
            y: 10,
            x: 5,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '10';
                })),
        BrnPointData(
            pointText: '40',
            y: 40,
            x: 6,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '40';
                })),
        BrnPointData(
            pointText: '100',
            y: 60,
            x: 7,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        BrnPointData(
            pointText: '100',
            y: 70,
            x: 8,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        BrnPointData(
            pointText: '100',
            y: 90,
            x: 9,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
        BrnPointData(
            pointText: '100',
            y: 80,
            x: 10,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '11';
                })),
        BrnPointData(
            pointText: '100',
            y: 100,
            x: 11,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '100';
                })),
      ],
      lineColor: Colors.blue,
    );

    _pointsLine2 = BrnPointsLine(
      lineWidth: 3,
      pointRadius: 4,
      isShowPoint: false,
      isCurve: true,
      points: [
        BrnPointData(
            pointText: '15',
            y: 15,
            x: 1,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '15';
                })),
        BrnPointData(
            pointText: '30',
            y: 30,
            x: 2,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '30';
                })),
        BrnPointData(
            pointText: '17',
            y: 17,
            x: 3,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '17';
                })),
        BrnPointData(
            pointText: '18',
            y: 25,
            x: 4,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '18';
                })),
        BrnPointData(
            pointText: '13',
            y: 40,
            x: 5,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '13';
                })),
        BrnPointData(
            pointText: '16',
            y: 30,
            x: 6,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '16';
                })),
        BrnPointData(
            pointText: '49',
            y: 49,
            x: 7,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '49';
                })),
        BrnPointData(
            pointText: '66',
            y: 66,
            x: 8,
            lineTouchData: BrnLineTouchData(onTouch: () {
              return '66';
            }, tipWindowSize: Size(60, 40))),
        BrnPointData(
            pointText: '77',
            y: 80,
            x: 9,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '77';
                })),
        BrnPointData(
            pointText: '88',
            y: 90,
            x: 10,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '88';
                })),
        BrnPointData(
            pointText: '99',
            y: 60,
            x: 11,
            lineTouchData: BrnLineTouchData(
                tipWindowSize: Size(60, 40),
                onTouch: () {
                  return '99';
                })),
      ],
      shaderColors: [
        Colors.green.withOpacity(0.3),
        Colors.green.withOpacity(0.01)
      ],
      lineColor: Colors.green,
    );

    pointsLineList.add(pointsLine);
    pointsLineList.add(_pointsLine2);
    return pointsLineList;
  }

  List<BrnDialItem> getYDialValuesForDemo3() {
    return [
      BrnDialItem(
        dialText: '自定义',
        dialTextStyle: TextStyle(fontSize: 10.0, color: Colors.green),
        value: 0,
      ),
      BrnDialItem(
        dialText: '20',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: 20,
      ),
      BrnDialItem(
        dialText: '40',
        dialTextStyle: TextStyle(fontSize: 10.0, color: Colors.red),
        value: 40,
      ),
      BrnDialItem(
        dialText: '60',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: 60,
      ),
      BrnDialItem(
        dialText: '80',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: 80,
      ),
      BrnDialItem(
        dialText: '100',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: 100,
      ),
      BrnDialItem(
        dialText: '120',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: 120,
      )
    ];
  }

  _getXDialValuesForDemo3(List<BrnPointsLine> lines) {
    List<BrnDialItem> _xDialValue = [];
    for (int index = 0; index < lines[0].points.length; index++) {
      _xDialValue.add(BrnDialItem(
        dialText: '${lines[0].points[index].x}',
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: lines[0].points[index].x,
      ));
    }
    return _xDialValue;
  }
}
