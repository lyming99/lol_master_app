import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_record_list_controller.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskStatisticController extends MvcController {
  var groupList = <StatisticStandardGroup>[];

  DateRange? selectedDateRange;

  DateRange? selectedRange;

  var recordListController = DeskRecordListController();

  int selectIndex = 0;

  var listPopupTime = 0;

  String get currentName =>
      selectIndex < groupList.length ? groupList[selectIndex].name ?? "" : "";

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  Future<void> fetchData() async {
    groupList = await StatisticStandardService.instance.getStandardGroupList();
    selectIndex = groupList.indexWhere((element) => element.selected == true);
    if (selectIndex == -1) {
      selectIndex = 0;
    }
    notifyListeners();
  }

  void updateSelectDateRange(DateRange? value) {
    selectedRange = value;
    notifyListeners();
  }

  void updateSelectGroup(int index) {
    selectIndex = index;
    notifyListeners();
  }
}
