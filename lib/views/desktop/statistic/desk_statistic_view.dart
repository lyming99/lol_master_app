import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'statistic_widgets/filter_view.dart';
import 'statistic_widgets/record_list_view.dart';
import 'statistic_widgets/statistic_view.dart';

/// 评分系统界面开发
class DeskStatisticView extends MvcView<DeskStatisticController> {
  const DeskStatisticView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1.日期+评分标准筛选过滤器
        FilterView(
          controller: controller,
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              // 2.相关性统计图+评分项目统计图
              StatisticView(
                controller: controller,
              ),
              // 3.复盘数据列表
              SizedBox(
                height: 500,
                child: DeskRecordListView(
                  controller: controller.recordListController,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
