import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'table_filter_widget.dart';

enum MyOrderType {
  none,
  asc,
  desc;
}

/// 表头数据：列宽，列名，过滤器数据，排序方式，列数据类型
class MyHeaderItem {
  int columnIndex;
  String? key;
  double preferWidth;
  double width;
  String name;
  List<dynamic> filters;
  MyOrderType orderType;
  String? columnType;
  bool editable;
  Object? value;

  // 下拉选择项目
  List<Object> selectFilters;

  // 下拉框数据类型编辑数据
  List<Object> items;
  double? flex;

  MyHeaderItem({
    this.columnIndex = 0,
    this.key,
    this.width = 80,
    this.preferWidth = 80,
    required this.name,
    this.filters = const [],
    this.columnType,
    this.orderType = MyOrderType.none,
    this.editable = false,
    this.selectFilters = const [],
    this.items = const [],
    this.value,
    this.flex,
  }) {
    init();
  }

  void init() {
    var inputWidth = preferWidth;
    var textPainter = TextPainter(
      text: TextSpan(
        text: name,
        style: const TextStyle(fontSize: 14, fontFamily: "微软雅黑"),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    width = 2 + textPainter.width + 16;
    if (filters.isNotEmpty) {
      width += 50;
    }
    preferWidth = width = max(inputWidth, 80);
  }

  // copy with
  MyHeaderItem copyWith({
    int? columnIndex,
    String? key,
    double? width,
    String? name,
    List<Object>? filters,
    MyOrderType? orderType,
    String? columnType,
    bool? editable,
    Object? value,
    List<Object>? selectFilters,
    List<Object>? items,
    double? flex,
    double? preferWidth,
  }) =>
      MyHeaderItem(
        columnIndex: columnIndex ?? this.columnIndex,
        key: key ?? this.key,
        width: width ?? this.width,
        name: name ?? this.name,
        filters: filters ?? this.filters,
        orderType: orderType ?? this.orderType,
        columnType: columnType ?? this.columnType,
        editable: editable ?? this.editable,
        value: value ?? this.value,
        selectFilters: selectFilters ?? this.selectFilters,
        items: items ?? this.items,
        flex: flex ?? this.flex,
        preferWidth: preferWidth ?? this.preferWidth,
      );
}

/// 内容数据：文字型、数值型、下拉框型，是否可以编辑
class MyCellItem {
  int colIndex;
  int rowIndex;
  dynamic value;
  Function(dynamic value)? onUpdate;

  MyCellItem({
    this.value,
    this.onUpdate,
    this.colIndex = 0,
    this.rowIndex = 0,
  });
}

/// 行数据
class MyRowItem {
  dynamic value;
  List<MyCellItem> cells;

  MyRowItem({
    this.value,
    this.cells = const [],
  });
}

/// 继承或者直接给数据？
/// 1.标题显示：内容，宽度
/// 2.数据显示
/// 3.数据过滤、数据排序
/// 4.数据入参
class MyTableController extends MvcController {
  List<MyHeaderItem> headers = [];
  List<MyRowItem> rows = [];

  int get rowCount => rows.length;

  double calcContentWidth(double maxWidth) {
    double result = 0;
    for (var i = 0; i < headers.length; i++) {
      var cellWidth = getColWidthBySize(maxWidth, i);
      headers[i].width = cellWidth;
      result += cellWidth;
    }
    return max(maxWidth, result);
  }

  double getColWidthBySize(double maxWidth, int colIndex) {
    var header = headers[colIndex];
    if (header.flex == null) {
      return header.width;
    }
    // flex 计算
    var sumFlex = headers
        .where((element) => element.flex != null)
        .map((e) => e.flex!)
        .reduce((value, element) => value + element);
    if (sumFlex == 0) {
      return header.width;
    }
    var flexWidth = maxWidth -
        headers
            .map((e) => e.preferWidth)
            .reduce((value, element) => value + element);
    if (flexWidth > 0) {
      var flexAdd = (header.flex!) * flexWidth / sumFlex;
      return (flexAdd + header.preferWidth);
    }
    return header.width;
  }

  void setData(List<MyHeaderItem> headers, List<MyRowItem> rows) {
    this.headers = headers;
    this.rows = rows;
    for (var i = 0; i < rows.length; i++) {
      for (var cell in rows[i].cells) {
        cell.rowIndex = i;
      }
    }
    notifyListeners();
  }

  List<dynamic> getCompareFunctions(
      List<TableFilterController<dynamic>> filterList) {
    var compareFunctions = [];
    for (var filter in filterList) {
      int colIndex =
          headers.indexWhere((element) => element.key == filter.columnKey);
      var orderType = filter.orderType;
      var comparator = filter.comparator;
      if (comparator == null) {
        continue;
      }
      switch (orderType) {
        case FilterOrderType.asc:
          compareFunctions.add((a, b) {
            return comparator.call(
                a.cells[colIndex].value, b.cells[colIndex].value);
          });
          break;
        case FilterOrderType.desc:
          compareFunctions.add((a, b) {
            return comparator.call(
                b.cells[colIndex].value, a.cells[colIndex].value);
          });
          break;
        case FilterOrderType.none:
          break;
      }
    }
    return compareFunctions;
  }

  List<dynamic> getFilterFunctions(
      List<TableFilterController<dynamic>> filterList) {
    var filterFunctions = [];
    for (var filter in filterList) {
      var items = filter.selectItems;
      if (items.isEmpty) {
        continue;
      }
      int colIndex =
          headers.indexWhere((element) => element.key == filter.columnKey);
      var equals = filter.filterEquals;
      if (equals == null) {
        continue;
      }
      filterFunctions.add(
        (value) => items.any(
          (item) {
            return equals.call(value.cells[colIndex].value, item);
          },
        ),
      );
    }
    return filterFunctions;
  }

  List<MyRowItem> getFilterResult(List<MyRowItem> rows,
      List<dynamic> filterFunctions, List<dynamic> compareFunctions) {
    var resultList = rows.where((element) {
      if (filterFunctions.isEmpty) {
        return true;
      }
      for (var filter in filterFunctions) {
        if (!filter.call(element)) {
          return false;
        }
      }
      return true;
    }).toList();
    resultList.sort((a, b) {
      for (var compare in compareFunctions) {
        var result = compare.call(a, b);
        if (result != 0) {
          return result;
        }
      }
      return 0;
    });
    return resultList;
  }
}

typedef HeaderBuilder = IndexedWidgetBuilder;
typedef FilterBuilder = IndexedWidgetBuilder;
typedef CellBuilder = Widget Function(
    BuildContext context, int rowIndex, int colIndex);

class MyTableWidget extends MvcView<MyTableController> {
  final HeaderBuilder? headerBuilder;
  final CellBuilder? cellBuilder;

  /// 构造方法
  const MyTableWidget({
    super.key,
    required super.controller,
    this.headerBuilder,
    this.cellBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.headers.isEmpty) {
      return Container();
    }
    var height = controller.rows.length * 50.0 + 50.0;
    return Container(
      margin: const EdgeInsets.all(16),
      alignment: Alignment.topLeft,
      child: SizedBox(
        height: height,
        child: LayoutBuilder(builder: (context, cons) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: controller.calcContentWidth(cons.maxWidth),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(
                        controller.calcContentWidth(cons.maxWidth), height),
                    painter: _BorderPainter(
                      controller: controller,
                      color: const Color(0xfff6dba6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 表头
                        SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              for (var i = 0;
                                  i < controller.headers.length;
                                  i++)
                                headerBuilder?.call(context, i) ??
                                    SizedBox(
                                      width: controller.headers[i].width,
                                    ),
                            ],
                          ),
                        ),
                        // 数据
                        for (var i = 0; i < controller.rows.length; i++)
                          SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                for (var j = 0;
                                    j < controller.rows[i].cells.length;
                                    j++)
                                  cellBuilder?.call(context, i, j) ??
                                      SizedBox(
                                        width: controller.headers[j].width,
                                      ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  MyTableController controller;
  Color color;
  Paint? borderPaint;

  _BorderPainter({
    required this.controller,
    this.color = Colors.grey,
  });

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var headers = controller.headers;
    borderPaint ??= Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    double offset = headers[0].width;
    double height = (controller.rowCount + 1) * 50;
    for (var i = 1; i < headers.length; i++) {
      // 绘制列式边框
      canvas.drawLine(
        Offset(offset, 1),
        Offset(offset, height - 1),
        borderPaint!,
      );
      offset += headers[i].width;
    }
    for (var i = 1; i < controller.rowCount + 1; i++) {
      // 绘制行式边框
      canvas.drawLine(
        Offset(1, i * 50),
        Offset(size.width - 1, i * 50),
        borderPaint!,
      );
    }
    canvas.drawRect(
        Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), borderPaint!);
  }
}
