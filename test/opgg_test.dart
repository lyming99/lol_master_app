import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

Future<void> main() async {
  var dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.findProxy = (host) {
      return "PROXY 127.0.0.1:10809";
    };
    client.badCertificateCallback = (cert, host, port) {
      return true;
    };
    return null;
  };
  // 用dio 设置代理
  var src = await dio.get("https://www.op.gg/champions");
  var html = src.data as String;
  var search = """<script id="__NEXT_DATA__" type="application/json">""";
  var startIndex = html.indexOf(search);
  var endIndex = html.indexOf("""</script>""",startIndex);
  var data = html.substring(startIndex+search.length,endIndex);
  File("e:/temp/opgg.html").writeAsString(data);
}
