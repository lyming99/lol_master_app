import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_statistic_controller.dart';
import 'package:lol_master_app/views/desktop/summoner/horizontal_button_widget.dart';

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
            width: 180,
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
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<StandardItem>(
                  value: controller.selectedStandard,
                  iconSize: 16,
                  onChanged: (StandardItem? newValue) {
                    controller.setSelectedStandard(newValue);
                  },
                  items: controller.standards
                      .map<DropdownMenuItem<StandardItem>>(
                          (StandardItem standard) {
                        return DropdownMenuItem<StandardItem>(
                          alignment: Alignment.centerLeft,
                          value: standard,
                          child: SizedBox(
                            height: 40.0, // 自定义每个菜单项的高度
                            child: Row(
                              children: [
                                Text(standard.name ?? ""),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
          Spacer(),
          HorizontalButtonWidget(
            onPressed: () {},
            icon: const Icon(Icons.settings_sharp),
            text: "评分标准管理",
          ),
        ],
      ),
    );
  }
}
