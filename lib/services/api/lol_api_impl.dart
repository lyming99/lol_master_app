import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lol_master_app/entities/account/lol_account.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:process_run/process_run.dart';

class LolApiImpl extends LolApi {
  String token = "S9OY3CfrUGTVo127EVZp2w";
  String port = "59940";
  Timer? loopTimer;
  bool gameStatusLoopStatus = false;
  bool connected = false;
  LolAccountInfo? accountInfo;

  @override
  void startClientLoop() {
    loopTimer ??= Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!await isClientRunning()) {
        if (connected) {
          connected = false;
          notifyListeners();
        }
        await readClientInfo();
      } else {
        if (!connected) {
          connected = true;
          notifyListeners();
        }
      }
      accountInfo = await queryAccountInfo();
      notifyListeners();
    });
    print('start client loop');
  }

  @override
  void startGameStatusLoop() async {
    if (gameStatusLoopStatus) {
      return;
    }
    gameStatusLoopStatus = true;
    print('start game status loop');
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));
      try {
        var status = await getGameStatus();
        if (status != null) {
          print("game status: $status");
          switch (status) {
            case GameStatusEnum.readyCheck:
              print("in game");
              await acceptGame();
              break;
            case GameStatusEnum.champSelect:
              print("in game champ select status.");
              await selectChamp();
              break;
            default:
              break;
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Future<bool> isClientRunning() async {
    var id = await getCurrentSummonerId();
    return id != null;
  }

  @override
  Future<void> readClientInfo() async {
    var shell = Shell(verbose: false);
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
          port = port.substring(0, port.indexOf("\""));
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
    Dio dio = createDio();
    var resp = await dio
        .put("https://127.0.0.1:$port/lol-perks/v1/pages/${page}", data: {
      "autoModifiedSelections": [],
      "current": true,
      "name": config.configName,
      "order": 0,
      "primaryStyleId": getRuneGroupId(config.primaryRuneKey ?? ""),
      "subStyleId": getRuneGroupId(config.secondaryRuneKey ?? ""),
      "selectedPerkIds": [
        for (var item in config.primaryRunes ?? []) int.parse(item.key),
        for (var item in config.secondaryRunes ?? []) int.parse(item.key),
        for (var item in config.thirdRunes ?? []) int.parse(item.key),
      ]
    });
    print('${resp.data}');
  }

  Dio createDio() {
    var dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 3),
      headers: {
        "Authorization": "Basic " + base64Encode(utf8.encode("riot:$token")),
      },
    ));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true;
      };
      return null;
    };
    return dio;
  }

  @override
  Future<int?> getCurrentSummonerId() async {
    try {
      Dio dio = createDio();
      var resp = await dio.get(
        "https://127.0.0.1:$port/lol-summoner/v1/current-summoner",
      );
      return resp.data['summonerId'];
    } catch (e) {
      return null;
    }
  }

  @override
  Future getEquipConfig() async {
    //GET /lol-item-sets/v1/item-sets/{summonerId}/sets
    var summonerId = await getCurrentSummonerId();
    Dio dio = createDio();
    var resp = await dio.get(
      "https://127.0.0.1:$port/lol-item-sets/v1/item-sets/$summonerId/sets",
    );
    return resp.data;
  }

  /// 1.查询已有装备
  /// 2.再已有装备列表中增加装备，jsonPath: "itemSets"
  @override
  Future putEquipConfig(EquipConfig content) async {
    Dio dio = createDio();
    var summonerId = await getCurrentSummonerId();
    var old = await getEquipConfig();
    var itemSet = {
      "associatedMaps": [11, 12],
      "blocks": [
        for (var group in content.equipGroupList)
          {
            "items": [
              for (var item in group.equipList) {"count": 1, "id": item.itemId}
            ],
            "type": group.name ?? "新的装配方案"
          }
      ],
      "title": content.name ?? "",
      "type": "custom"
    };
    if (old is Map) {
      bool isExist = false;
      for (var item in old["itemSets"]) {
        if (item["title"] == content.name) {
          item["blocks"] = itemSet["blocks"];
          isExist = true;
          break;
        }
      }
      if (!isExist) {
        (old["itemSets"] as List).add(itemSet);
      }
      var resp = await dio.put(
          "https://127.0.0.1:$port/lol-item-sets/v1/item-sets/$summonerId/sets",
          data: old);
      return resp.data;
    } else {
      var resp = await dio.put(
          "https://127.0.0.1:$port/lol-item-sets/v1/item-sets/$summonerId/sets",
          data: {
            "accountId": summonerId,
            "itemSets": [
              itemSet,
            ]
          });
      return resp.data;
    }
  }

  String get baseUrl => "https://127.0.0.1:$port";

  @override
  LolAccountInfo? getAccountInfo() {
    return accountInfo;
  }

  @override
  bool hasLogin() {
    return accountInfo != null;
  }

  @override
  String getAccountIcon() {
    return "assets/lol/img/profileicon/${accountInfo?.profileIconId}.png";
  }

  Future<LolAccountInfo?> queryAccountInfo() async {
    try {
      var id = await getCurrentSummonerId();
      Dio dio = createDio();
      var resp = await dio.get("$baseUrl/lol-summoner/v1/summoners/$id");
      return LolAccountInfo.fromJson(resp.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<GameStatusEnum?> getGameStatus() async {
    var dio = createDio();
    var resp = await dio.get("$baseUrl/lol-gameflow/v1/gameflow-phase");
    return GameStatusEnum.fromString(resp.data?.toString() ?? "");
  }

  @override
  Future<void> acceptGame() async {
    var config = await LolConfigService.instance.getCurrentConfig();
    if (config?.autoAccept != true) {
      return;
    }
    var delay = config?.autoAcceptDelay ?? 0;
    if (delay > 0) {
      await Future.delayed(Duration(seconds: delay));
    }
    var dio = createDio();
    await dio.post("$baseUrl/lol-matchmaking/v1/ready-check/accept");
  }

  @override
  Future<Map?> getChampSelectInfo() async {
    try {
      var dio = createDio();
      var resp = await dio.get("$baseUrl/lol-champ-select/v1/session");
      print(jsonEncode(resp.data));
      return resp.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> selectChamp() async {
    var selectInfo = await getChampSelectInfo();
    if (selectInfo == null) {
      return;
    }
    var currentId = selectInfo['localPlayerCellId'];
    for (var action in selectInfo["actions"]) {
      for (var item in action) {
        if (item['actorCellId'] == currentId) {
          int actionId = item["id"];
          String type = item["type"];
          if ("pick" == type) {
            //报错处理? {"errorCode":"RPC_ERROR","httpStatus":500,"implementationDetails":{},"message":"Error response for PATCH /lol-lobby-team-builder/champ-select/v1/session/actions/2: Unable to process action change: Received status Error: INVALID_STATE instead of expected status of OK from request to teambuilder-draft:updateActionV1"}
            await pickChampion(actionId);
          } else {
            banChampion();
          }
        }
      }
    }
  }

  // 选择英雄
  Future<void> pickChampion(int actionId) async {
    var config = await LolConfigService.instance.getCurrentConfig();
    if (config?.autoSelect != true) {
      return;
    }
    var primaryHero = config?.primaryHero;
    var secondaryHero = config?.secondaryHero;
    // 1.读取配置首选、次选英雄
    // 2.调用接口选择英雄
    // 3.如果接口报错，那么选择次选英雄
    var dio = createDio();
    var isOk = await selectChampion(dio, actionId, primaryHero);
    if (!isOk) {
      await selectChampion(dio, actionId, secondaryHero);
    }
  }

  Future<bool> selectChampion(Dio dio, int actionId, int? heroId,
      [int retryCount = 3]) async {
    for (var i = 0; i < retryCount; i++) {
      try {
        var resp = await dio.patch(
            "$baseUrl/lol-champ-select/v1/session/actions/$actionId",
            data: {"completed": true, "type": "pick", "championId": heroId});
        print(jsonEncode(resp.data));
        return true;
      } catch (e) {
        print(e);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    return false;
  }

  Future<void> banChampion() async {}

  @override
  Future<String?> getCurrentSummonerPuuid() async {
    try {
      Dio dio = createDio();
      var resp = await dio.get(
        "https://127.0.0.1:$port/lol-summoner/v1/current-summoner",
      );
      return resp.data['puuid'];
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map?> queryMatchHistory(String? puuid, int pageIndex) async {
    var dio = createDio();
    if (puuid == null || puuid == "") {
      puuid = await getCurrentSummonerPuuid();
    }
    var resp = await dio.get(
        "$baseUrl/lol-match-history/v1/products/lol/$puuid/matches?begIndex=${pageIndex * 10}&endIndex=${pageIndex * 10 + 10}");
    return resp.data;
  }

  @override
  Future<Map?> queryGameDetailInfo(int? gameId) async {
    ///lol-match-history/v1/games/{gameId}
    var dio = createDio();
    var resp = await dio.get("$baseUrl/lol-match-history/v1/games/$gameId");
    return resp.data;
  }

  @override
  Future<Map?> queryRankInfo(String? puuid) async {
    /// /lol-ranked/v1/ranked-stats/{puuid}
    var dio = createDio();
    var resp = await dio.get("$baseUrl/lol-ranked/v1/ranked-stats/$puuid");
    return resp.data;
  }
}

enum GameStatusEnum {
  /// 无(游戏大厅)
  none,

  /// 组队房间内
  lobby,

  /// 寻找匹配对局中
  matchmaking,

  /// 找到对局,等待接受
  readyCheck,

  /// 选英雄中
  champSelect,

  /// 游戏开始
  gameStart,

  /// 游戏中
  inProgress,

  /// 游戏即将结束
  preEndOfGame,

  /// 等待结算页面
  waitingForStats,

  /// 游戏结束
  endOfGame,

  /// 重新连接
  reconnect,

  /// 观战中
  watchInProgress;

  // 静态方法，根据字符串获取枚举值
  static GameStatusEnum fromString(String value) {
    return GameStatusEnum.values.firstWhere(
      (e) =>
          e.toString().toLowerCase() == 'GameStatusEnum.$value'.toLowerCase(),
      orElse: () => GameStatusEnum.none,
    );
  }
}
