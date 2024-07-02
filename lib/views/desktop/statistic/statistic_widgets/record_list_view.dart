import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_record_list_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

/// 评分记录列表
/// 表头
/// 数据
/// 分页
class DeskRecordListView extends MvcView<DeskRecordListController> {
  const DeskRecordListView({super.key, required super.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 500,
      child: Column(
        children: [
          for (var i = 0; i < 10; i++)
            Container(
              height: 40,
              child: Row(children: [
                Text("2023-05-01"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄1"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄2"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄3"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄4"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄5"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄6"),
                SizedBox(
                  width: 16,
                ),
                Text("英雄7"),
              ]),
            ),
        ],
      ),
    );
  }
}
