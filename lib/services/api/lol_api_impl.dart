import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:process_run/process_run.dart';

class LolApiImpl implements LolApi {
  String token = "hRtOdIL6WiHwyYkJLmllVA";
  String port = "53848";

  @override
  Future<void> readClientInfo() async {
    var shell = Shell();
    var result = await shell.run(
        "WMIC PROCESS WHERE \"name='LeagueClientUx.exe'\" GET commandline");
    for (var line in result) {
      if (line.outText.contains("--remoting-auth-token=")) {
        token = line.outText.split("--remoting-auth-token=")[1];
        if (token.contains("\"")) {
          token = token.substring(0, token.indexOf("\""));
        }
      }
      if (line.outText.contains("--app-port=")) {
        port = line.outText.split("--app-port=")[1];
        if (port.contains("\"")) {
          port = port.substring(0, token.indexOf("\""));
        }
      }
    }
  }

  @override
  Future<String?> getCurrentRuneId() async {
    var dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 1),
    ));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return null;
    };
    var resp = await dio.get("https://127.0.0.1:$port/lol-perks/v1/pages",
        options: Options(headers: {
          "Authorization": "Basic " + base64Encode(utf8.encode("riot:$token")),
        }),
        data: {});
    print('${resp.data}');
    var data = resp.data;
    if (data is List) {
      for (var item in data) {
        if (item['current'] == true) {
          return item['id'].toString();
        }
      }
    }
    return "";
  }

  int getRuneGroupId(String key) {
    switch (key) {
      case "Precision":
        return 8000;
      case "Domination":
        return 8100;
      case "Sorcery":
        return 8200;
      case "Inspiration":
        return 8300;
      case "Resolve":
        return 8400;
      default:
        return 8000;
    }
  }

  @override
  Future<void> putRune(RuneConfig config) async {
    var page = await getCurrentRuneId();
    var dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 1),
    ));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return null;
    };
    var resp =
        await dio.put("https://127.0.0.1:$port/lol-perks/v1/pages/${page}",
            options: Options(headers: {
              "Authorization":
                  "Basic " + base64Encode(utf8.encode("riot:$token")),
            }),
            data: {
          "autoModifiedSelections": [],
          "current": true,
          "name": config.configName,
          "order": 0,
          "primaryStyleId": getRuneGroupId(config.primaryRuneKey ?? ""),
          "subStyleId": getRuneGroupId(config.secondaryRuneKey ?? ""),
          "selectedPerkIds": [
            for(var item in config.primaryRunes??[]) int.parse(item.key),
            for(var item in config.secondaryRunes??[]) int.parse(item.key),
            for(var item in config.thirdRunes??[]) int.parse(item.key),
          ]
        });
    print('${resp.data}');
  }
}
