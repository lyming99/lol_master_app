import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:lol_master_app/entities/account/lol_account.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/lol/game_info.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';
import 'package:lol_master_app/services/rune/rune_service.dart';
import 'package:lol_master_app/util/date_utils.dart';
import 'package:process_run/process_run.dart';

import '../hero/hero_service.dart';

class LolApiImpl extends LolApi {
  String token = "S9OY3CfrUGTVo127EVZp2w";
  String port = "59940";
  Timer? loopTimer;
  bool gameStatusLoopStatus = false;
  bool connected = false;
  LolAccountInfo? accountInfo;
  int lastQueryTime = 0;
  int? lastQueryGameId;

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
      await Future.delayed(const Duration(milliseconds: 1200));
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
              getRoomInfo(false);
              // 加点延时，给钱优化(增加稳定性)
              await Future.delayed(const Duration(milliseconds: 1000));
              await selectChamp();
              break;
            case GameStatusEnum.inProgress:
              //游戏进程，查询所有人的战绩，显示到对局信息里面
              //再游戏进程中，应该需要用其他接口差对局信息
              //咱们只是查询的房间选择时的召唤师信息，因为房间会隐藏掉对面召唤师信息
              getRoomInfo(true);
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
    return "https://game.gtimg.cn/images/lol/act/img/profileicon/${accountInfo?.profileIconId}.png";
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
      return resp.data;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<Map?> getGameSessionInfo() async {
    try {
      var dio = createDio();
      var resp = await dio.get("$baseUrl/lol-gameflow/v1/session");
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
    var thirdHero = config?.thirdHero;
    // 1.读取配置首选、次选英雄
    // 2.调用接口选择英雄
    // 3.如果接口报错，那么选择次选英雄
    var dio = createDio();
    var isOk = await selectChampion(dio, actionId, primaryHero);
    if (!isOk) {
      isOk = await selectChampion(dio, actionId, secondaryHero);
    }
    if (!isOk) {
      isOk = await selectChampion(dio, actionId, thirdHero);
    }
  }

  Future<bool> selectChampion(Dio dio, int actionId, int? heroId,
      [int retryCount = 3]) async {
    if (heroId == null) {
      return false;
    }
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

  @override
  Future<List<String>> querySummonerIdList(String name) async {
    var dio = createDio();
    var resp = await dio.get("$baseUrl/lol-summoner/v1/summoners?name=$name");
    return resp.data;
  }

  @override
  Future<String?> queryPuuidByAlias(String gameName, String tagLine) async {
    var dio = createDio();
    var resp = await dio.get(
        "$baseUrl/lol-summoner/v1/alias/lookup?gameName=$gameName&tagLine=$tagLine");
    return resp.data['puuid'];
  }

  @override
  Future<dynamic> queryChatConversations() async {
    var dio = createDio();
    var resp = await dio.get("$baseUrl/lol-chat/v1/conversations");
    return resp.data;
  }

  @override
  Future queryConversationMessages(String? conversationId) async {
    var dio = createDio();
    var resp = await dio
        .get("$baseUrl/lol-chat/v1/conversations/$conversationId/messages");
    return resp.data;
  }

  @override
  Future queryGameSession() async {
    var dio = createDio();
    var resp = await dio.get("$baseUrl/lol-gameflow/v1/session");
    return resp.data;
  }

  /// 查询历史战绩信息，第一个会有段位信息
  @override
  Future<List<HistoryInfo>?> queryMatchHistoryInfo(
      String? puuid, int pageCount) async {
    var dio = createDio();
    if (puuid == null || puuid == "") {
      puuid = await getCurrentSummonerPuuid();
    }
    var resp = await dio.get(
        "$baseUrl/lol-match-history/v1/products/lol/$puuid/matches?begIndex=0&endIndex=$pageCount");
    var historyList = resp.data as Map;
    var games = historyList["games"]["games"];
    var historyInfoList = <HistoryInfo>[];
    String? rankLevel;
    for (var item in games) {
      var heroId = item["participants"].first["championId"];
      var heroIcon = await HeroService.instance.getHeroIcon(heroId?.toString());
      var summonerId =
          item["participantIdentities"].first["player"]["summonerId"];
      var userName = item["participantIdentities"].first["player"]["gameName"];
      var gameId = item["gameId"];
      var gameType = item["gameType"];
      var mapId = item["mapId"];
      // 2024-06-20T12:57:56.218Z
      var gameDate = MyDateUtils.formatUtcDateToDate(item["gameCreationDate"]);
      var gameDuration = item["gameDuration"];
      var gameResult = item["participants"].first["stats"]["win"];
      var queueId = item["queueId"];
      var historyInfo = HistoryInfo(
        userName: userName,
        summonerId: summonerId,
        heroId: heroId?.toString(),
        heroIcon: heroIcon,
        gameId: gameId,
        gameType: gameType,
        mapId: mapId,
        gameDate: gameDate,
        gameDuration: gameDuration,
        gameResult: gameResult,
        queueId: queueId,
      );
      // 这里主要查询kda、段位
      var player = await queryGamePlayerKda(gameId, puuid, rankLevel == null);
      if (player != null) {
        // 缓存段位，无需查询多次
        rankLevel = "${player.rankLevel1}${player.rankLevel2}";
      }
      historyInfo.currentPlayer = player;
      historyInfoList.add(historyInfo);
    }
    return historyInfoList;
  }

  Future<Player?> queryGamePlayerKda(
      int gameId, String? puuid, bool queryRankInfo) async {
    var json = await LolApi.instance.queryGameDetailInfo(gameId);
    if (json == null) {
      return null;
    }
    var teams = <String, List<Player>>{};
    var participantIdentities = json["participantIdentities"];
    var participants = json["participants"];
    for (var item in participants) {
      var player = Player();
      var teamId = item["teamId"].toString();
      teams.putIfAbsent(teamId, () => []).add(player);
      player.heroId = item["championId"].toString();
      player.heroIcon = await HeroService.instance.getHeroIcon(player.heroId);
      participantIdentities.where((element) {
        return element["participantId"] == item["participantId"];
      }).forEach((element) {
        player.userName = element["player"]["gameName"];
        player.puuid = element["player"]["puuid"];
      });
      if (player.puuid != puuid) {
        continue;
      }
      if (queryRankInfo) {
        var rankInfo = await LolApi.instance.queryRankInfo(player.puuid);
        if (rankInfo != null) {
          player.rankLevel1 = getRankLevel1Str(
              rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["tier"]);
          player.rankLevel2 = getRankLevel2Str(
              rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["division"]);
        }
      }
      player.kills = item["stats"]["kills"];
      player.deaths = item["stats"]["deaths"];
      player.assists = item["stats"]["assists"];
      player.kda = "${player.kills}/${player.deaths}/${player.assists}";

      player.primaryRune = item["stats"]["perkPrimaryStyle"]?.toString();
      player.secondaryRune = item["stats"]["perkSubStyle"]?.toString();
      //根据perkPrimaryStyle得到符文图片
      player.primaryRuneIcon =
          await RuneService.instance.getRuneIcon(player.primaryRune);
      player.secondaryRuneIcon =
          await RuneService.instance.getRuneIcon(player.secondaryRune);
      player.spell1Id = item["spell1Id"]?.toString();
      player.spell2Id = item["spell2Id"]?.toString();
      player.spell1Icon =
          await RuneService.instance.getSummonerSpell(player.spell1Id);
      player.spell2Icon =
          await RuneService.instance.getSummonerSpell(player.spell2Id);
      player.win = item["stats"]["win"];

      player.item1 = item["stats"]["item0"]?.toString();
      player.item2 = item["stats"]["item1"]?.toString();
      player.item3 = item["stats"]["item2"]?.toString();
      player.item4 = item["stats"]["item3"]?.toString();
      player.item5 = item["stats"]["item4"]?.toString();
      player.item6 = item["stats"]["item5"]?.toString();
      player.item7 = item["stats"]["item6"]?.toString();
      return player;
    }
    return null;
  }

  @override
  String? getRankLevel1Str(String? level1) {
    switch (level1) {
      case "IRON":
        return "黑铁";
      case "BRONZE":
        return "青铜";
      case "SILVER":
        return "白银";
      case "GOLD":
        return "黄金";
      case "PLATINUM":
        return "铂金";
      case "EMERALD":
        return "翡翠";
      case "DIAMOND":
        return "钻石";
      case "MASTER":
        return "超凡大师";
      case "GRANDMASTER":
        return "傲娇宗师";
      case "CHALLENGER":
        return "最强王者";
      case "NA":
        return "未定级";
      default:
        return level1;
    }
  }

  @override
  String getRankLevel2Str(String? level2) {
    if (level2 == null || level2 == "NA") {
      return "未定级";
    }
    return level2;
  }

  Future<void> getRoomInfo(bool isInGameProgress) async {
    if (DateTime.now().millisecondsSinceEpoch - lastQueryTime < 30000) {
      /// 上次查询间隔大于30秒才进行下次查询
      /// 以为游戏状态时轮询检测的，进入房间会触发查询
      /// 只需查询一次，减少查询次数，避免频繁查询
      return;
    }
    lastQueryTime = DateTime.now().millisecondsSinceEpoch;
    var currentPuuid = await getCurrentSummonerPuuid();
    // myTeam
    try {
      /// 将接口返回保存，用于定位问题
      var playerList = <Player>[];
      var championIdList = <String>[];
      int? gameId;
      if (isInGameProgress) {
        // 在游戏进程，查询战绩，识别大哥大，大哥，小哥，小弟，小妹
        var gameSession = await getGameSessionInfo();

        if (gameSession != null) {
          var oneTeam = gameSession["gameData"]["teamOne"] as List?;
          var twoTeam = gameSession["gameData"]["teamTwo"] as List?;
          if (oneTeam?.every((element) => element["puuid"] == currentPuuid) ==
              true) {
            var temp = oneTeam;
            oneTeam = twoTeam;
            twoTeam = temp;
          }
          gameId = gameSession["gameData"]["gameId"];
          var list = [
            ...(oneTeam ?? []),
            ...(twoTeam ?? []),
          ];
          for (var item in list) {
            var puuid = item['puuid'] ?? "";
            playerList.add(Player()
              ..puuid = puuid
              ..heroId = item["championId"]?.toString() ?? "");
            championIdList.add(item["championId"]?.toString() ?? "");
          }
        }
      } else {
        var roomSession = await getChampSelectInfo();
        gameId = roomSession?["gameId"];
        // 在房间中读取召唤师信息，查询战绩，识别大哥大，大哥，小哥，小弟，坑比
        // myTeam,theirTeam
        var teamList = [
          ...(roomSession?["myTeam"] ?? []),
        ];
        for (var item in teamList) {
          var puuid = item['puuid'] ?? "";
          playerList.add(Player()
            ..puuid = puuid
            ..heroId = item["championId"]?.toString() ?? "");
          championIdList.add(item["championId"]?.toString() ?? "");
        }
      }
      // 如果是游戏进程，就不重复读取信息，避免一直刷新，过于频繁
      if (gameId == lastQueryGameId && isInGameProgress) {
        var update = this.myTeamPlayers == null ||
            this.myTeamPlayers!.length != playerList.length ||
            this.myTeamPlayers!.every((element) =>
                !playerList.every((e) => e.puuid == element.puuid));
        if (!update) {
          return;
        }
      }
      lastQueryGameId = gameId;

      /// 读取召唤师战绩和胜率，识别大哥大
      List<List<HistoryInfo>> myTeamHistoryInfo = [];
      List<Player> myTeamPlayers = [];
      List<double> winRateList = [];
      for (var i = 0; i < playerList.length; i++) {
        var puuid = playerList[i].puuid;
        var championId = championIdList[i];
        var historyInfo = <HistoryInfo>[];
        if (puuid != "" && puuid != null) {
          try {
            historyInfo = await queryMatchHistoryInfo(puuid, 20) ?? [];
          } catch (e) {
            print(e);
          }
        }
        myTeamHistoryInfo.add(historyInfo);
        var winCount = historyInfo
            .where((element) =>
                element.gameResult == true && element.getGameTypeStr() == "单双排")
            .length;
        var gameCount = historyInfo
            .where((element) => element.getGameTypeStr() == "单双排")
            .length;
        if (gameCount > 0) {
          winRateList.add((winCount / gameCount * 100.0));
        } else {
          winRateList.add(0);
        }
        // 没有历史战绩，所以需要读取召唤师信息
        if (historyInfo.isEmpty) {
          if (puuid == "" || puuid == null) {
            var player = playerList[i];
            player.userName = "电脑";
            player.heroIcon =
                await HeroService.instance.getHeroIcon(playerList[i].heroId);
            player.rankLevel1 = "未定级";
            player.rankLevel2 = "";
            myTeamPlayers.add(player);
          } else {
            var summonerInfo =
                await LolApi.instance.querySummonerInfoByPuuid(puuid ?? "");
            if (summonerInfo != null) {
              var player = Player();
              player.userName = summonerInfo["gameName"];
              player.puuid = puuid;
              if (championId != "" && championId != "0") {
                player.heroId = championId;
                player.heroIcon =
                    await HeroService.instance.getHeroIcon(championId);
              }
              var rankInfo = await LolApi.instance.queryRankInfo(puuid);
              if (rankInfo != null) {
                player.rankLevel1 = getRankLevel1Str(
                    rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["tier"]);
                player.rankLevel2 = getRankLevel2Str(
                    rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["division"]);
              }
              myTeamPlayers.add(player);
            }
          }
        } else {
          var player = historyInfo.first.currentPlayer!.copy();
          if (championId != "" && championId != "0") {
            player.heroId = championId;
            player.heroIcon =
                await HeroService.instance.getHeroIcon(championId);
          }
          myTeamPlayers.add(player);
        }
      }
      var userTypeLevel = [
        "大哥大",
        "大哥大",
        "大哥",
        "大哥",
        "小哥",
        "小哥",
        "小弟",
        "小弟",
        "小妹",
        "小妹"
      ];
      var sortMap = [
        for (var i = 0; i < winRateList.length; i++)
          {"index": i, "winRate": winRateList[i]},
      ];
      sortMap.sort((a, b) => b["winRate"]!.compareTo(a["winRate"]!));
      var userLevelList = [
        for (var i = 0; i < sortMap.length; i++)
          {"index": sortMap[i]["index"], "userTypeLevel": userTypeLevel[i]},
      ];
      userLevelList
          .sort((a, b) => (a["index"] as int).compareTo((b["index"] as int)));
      this.userLevelList =
          userLevelList.map((e) => e["userTypeLevel"] as String).toList();
      this.myTeamPlayers = myTeamPlayers;
      this.myTeamHistoryInfo = myTeamHistoryInfo;
    } catch (e) {
      // myTeamHistoryInfo = null;
      // myTeamPlayers = null;
      // lastQueryTime = 0;
    }
    // otherTeam?
    notifyListeners();
  }

  @override
  Future<dynamic> querySummonerInfoByPuuid(String puuid) async {
    var dio = createDio();
    var resp =
        await dio.get("$baseUrl/lol-summoner/v2/summoners/puuid/${puuid}");
    return resp.data;
  }
}
