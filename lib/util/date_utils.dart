import 'package:intl/intl.dart';

class MyDateUtils {
  MyDateUtils._internal();

  static DateFormat utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static DateFormat ymdFormat = DateFormat("yyyy-MM-dd");

  static String formatUtcDateToDate(String utcDate) {
    var date = utcFormat.parse(utcDate);
    return ymdFormat.format(date);
  }
}
