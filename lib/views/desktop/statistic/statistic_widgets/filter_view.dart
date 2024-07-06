import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/views/desktop/statistic/desk_standard_manager_view.dart';
import 'package:lol_master_app/views/desktop/summoner/horizontal_button_widget.dart';
import 'package:lol_master_app/widgets/circle_button.dart';
import 'package:lol_master_app/widgets/popup_dialog.dart';
import 'package:lol_master_app/widgets/popup_window.dart';

class FilterView extends StatelessWidget {
  final DeskStatisticController controller;

  const FilterView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          Text("日期范围:"),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 200,
            height: 32,
            child: DateRangeField(
              decoration: const InputDecoration(
                hintText: "请选择日期范围",
                hintStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 246, 219, 166))),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 246, 219, 166))),
              ),
              onDateRangeSelected: (DateRange? value) {
                // Handle the selected date range here
                controller.updateSelectDateRange(value);
                // controller.recordListController.updateStatistic(context);
              },
              selectedDateRange: controller.filterParams.selectedDateRange,
              pickerBuilder: datePickerBuilder,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text("评分标准："),
          SizedBox(
            width: 8,
          ),
          Container(
            width: 180,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xfff6dba6)),
            ),
            child: Builder(builder: (context) {
              return CircleButton(
                onTap: () {
                  showStandardItemListViewPopup(context);
                },
                radius: 0,
                child: SizedBox(
                  width: 160,
                  height: 30,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text(controller.currentName)),
                      const Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          Spacer(),
          HorizontalButtonWidget(
            onPressed: () {
              showManagerDialog(context);
            },
            icon: const Icon(Icons.settings_sharp),
            text: "标准管理",
          ),
        ],
      ),
    );
  }

  void showManagerDialog(BuildContext context) {
    showMyCustomDialog(
        context: context,
        builder: (context) {
          return DeskStandardManagerView(
            controller: DeskStandardManagerController(),
          );
        }).then((value) => controller.fetchData());
  }

  void showStandardItemListViewPopup(BuildContext context) {
    if (controller.listPopupTime + 200 <
        DateTime.now().millisecondsSinceEpoch) {
      showCustomDropMenu(
        context: context,
        modal: false,
        width: 252,
        height: 252,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 23, 29),
              border: Border.all(
                color: const Color(0xfff6dba6),
              ),
            ),
            child: Material(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  var item = controller.groupList[index];
                  return InkWell(
                    onTap: () {
                      closePopupWindow(context);
                      controller.updateSelectGroup(index);
                    },
                    child: ListTile(
                      title: Text(item.name ?? "未命名标准"),
                    ),
                  );
                },
                itemCount: controller.groupList.length,
              ),
            ),
          );
        },
      ).then((value) =>
          controller.listPopupTime = DateTime.now().millisecondsSinceEpoch);
    }
  }

  Widget datePickerBuilder(
          BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
          [bool doubleMonth = true]) =>
      DateRangePickerWidget(
        doubleMonth: doubleMonth,
        quickDateRanges: [
          QuickDateRange(dateRange: null, label: "清除快速选择"),
          QuickDateRange(
            label: '最近3天',
            dateRange: DateRange(
              DateTime.now().subtract(const Duration(days: 3)),
              DateTime.now(),
            ),
          ),
          QuickDateRange(
            label: '最近7天',
            dateRange: DateRange(
              DateTime.now().subtract(const Duration(days: 7)),
              DateTime.now(),
            ),
          ),
          QuickDateRange(
            label: '最近30天',
            dateRange: DateRange(
              DateTime.now().subtract(const Duration(days: 30)),
              DateTime.now(),
            ),
          ),
        ],
        initialDateRange: controller.filterParams.selectedDateRange,
        initialDisplayedDate:
        controller.filterParams.selectedDateRange?.start ?? DateTime(2023, 11, 20),
        onDateRangeChanged: onDateRangeChanged,
        height: 310,
        theme: const CalendarTheme(
          selectedColor: Color(0xffb67100),
          inRangeColor: Color(0xffb67100),
          dayNameTextStyle: TextStyle(color: Colors.white, fontSize: 10),
          inRangeTextStyle: TextStyle(color: Color(0xfff6f6f6)),
          selectedTextStyle: TextStyle(color: Color(0xfff6f6f6)),
          todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
          defaultTextStyle: TextStyle(color: Colors.white, fontSize: 12),
          radius: 0,
          tileSize: 36,
          disabledTextStyle: TextStyle(color: Colors.grey),
          monthTextStyle: TextStyle(color: Color(0xffe8be72)),
          quickDateRangeTextStyle: TextStyle(color: Color(0xffe8be72)),
          selectedQuickDateRangeColor: Color(0xffe8be72),
        ),
      );
}
