import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:process_run/process_run.dart';

void main() async {
  var shell = Shell();
  var result = await shell.run("WMIC PROCESS WHERE \"name='LeagueClientUx.exe'\" GET commandline");
  result.forEach((element) {
    print(element.outText);
  });
  String token = "2_5mUFCm1TmSKEOwjQE3aQ";
  String port = "64350";
  var dio = Dio(BaseOptions(
    connectTimeout: Duration(seconds: 1),
  ));
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.badCertificateCallback = (cert, host, port) {
      return true;
    };
    return null;
  };
  var resp =
      await dio.put("https://127.0.0.1:$port/lol-perks/v1/pages/1016999436",
          options: Options(headers: {
            //"Authorization": "Basic " + base64Encode(utf8.encode("$token:")),
            "Authorization":
                "Basic " + base64Encode(utf8.encode("riot:$token")),
          }),
          data: {
        "autoModifiedSelections": [],
        "current": true,
        "name": "测试符文页",
        "order": 0,
        "primaryStyleId": 8400,
        "subStyleId": 8300,
        "selectedPerkIds": [
          8439,
          8446,
          8429,
          8451,
          8345,
          8347,
          5007,
          5002,
          5001
        ]
      });
  print('${resp.data}');
}
