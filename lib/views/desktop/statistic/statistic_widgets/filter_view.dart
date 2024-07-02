import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/views/desktop/statistic/desk_standard_manager_view.dart';
import 'package:lol_master_app/views/desktop/summoner/horizontal_button_widget.dart';
import 'package:lol_master_app/widgets/circle_button.dart';
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
              },
              selectedDateRange: controller.selectedRange,
              pickerBuilder: (BuildContext context,
                  dynamic Function(DateRange?) onDateRangeChanged) {
                return DateRangePickerWidget(
                  doubleMonth: true,
                  height: 330,
                  initialDateRange: controller.selectedRange,
                  onDateRangeChanged: onDateRangeChanged,
                );
              },
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
            text: "评分标准管理",
          ),
        ],
      ),
    );
  }

  void showManagerDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          margin:
              const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xff091b20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xffe8be72)),
                ),
                clipBehavior: Clip.antiAlias,
                child: DeskStandardManagerView(
                  controller: DeskStandardManagerController(),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff091b20),
                        borderRadius: BorderRadius.circular(80),
                        border: Border.all(color: const Color(0xffe8be72)),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Color(0xffe8be72),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) => controller.fetchData());
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
}
