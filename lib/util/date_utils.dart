import 'package:intl/intl.dart';

class MyDateUtils {
  MyDateUtils._internal();

  static DateFormat utcFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static DateFormat ymdFormat = DateFormat("yyyy-MM-dd");
  static DateFormat ymdhmsFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  static String formatUtcDateToDate(String utcDate) {
    var date = utcFormat.parse(utcDate);
    return ymdFormat.format(date);
  }
  static String formatUtcDateToDateTime(String utcDate) {
    var date = utcFormat.parse(utcDate);
    return ymdhmsFormat.format(date);
  }
}
