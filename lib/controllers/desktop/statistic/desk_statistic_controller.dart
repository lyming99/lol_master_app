import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:lol_master_app/controllers/desktop/statistic/desk_record_list_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

class StandardItem {
  String? name;

  StandardItem({this.name});
}

class DeskStatisticController extends MvcController {
  StandardItem? selectedStandard;

  var standards = <StandardItem>[
    StandardItem(name: "默认标准A"),
    StandardItem(name: "默认标准B"),
    StandardItem(name: "默认标准C"),
  ];

  DateRange? selectedDateRange;

  DateRange? selectedRange;

  var recordListController = DeskRecordListController();

  void updateSelectDateRange(DateRange? value) {
    selectedRange = value;
    notifyListeners();
  }

  void setSelectedStandard(StandardItem? newValue) {
    selectedStandard = newValue;
    notifyListeners();
  }
}
