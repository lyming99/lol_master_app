import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';
import 'package:lol_master_app/services/rune/rune_service.dart';
import 'package:lol_master_app/services/statistic/statistic_standard_service.dart';
import 'package:lol_master_app/util/date_utils.dart';
import 'package:lol_master_app/util/mvc.dart';
import '../../../entities/lol/game_info.dart';

/// 1.查询战绩列表(待优化：召唤师名称显示)
/// 2.查询战绩详情(待优化：战绩title显示)
/// 3.刷新列表按钮
class DeskMatchHistoryController extends MvcController {
  // 前进后退栈
  List<PageInfo> pageInfoQueue = [];
  int currentPageInfoIndex = 0;
  var loadingList = false;
  var loadingDetail = false;
  String? gameId;

  DeskMatchHistoryController({
    this.gameId,
  });

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
    LolApi.instance.addListener(refreshOnClientUpdateStatus);
  }

  @override
  void onDispose() {
    super.onDispose();
    LolApi.instance.removeListener(refreshOnClientUpdateStatus);
  }

  @override
  void onDidUpdateWidget(BuildContext context,
      covariant DeskMatchHistoryController oldController) {
    super.onDidUpdateWidget(context, oldController);
    pageInfoQueue = oldController.pageInfoQueue;
    currentPageInfoIndex = oldController.currentPageInfoIndex;
    loadingList = oldController.loadingList;
    loadingDetail = oldController.loadingDetail;
    LolApi.instance.removeListener(oldController.refreshOnClientUpdateStatus);
    LolApi.instance.addListener(refreshOnClientUpdateStatus);
  }

  PageInfo? get currentPage {
    // 重置
    if (pageInfoQueue.isEmpty) {
      currentPageInfoIndex = 0;
      pageInfoQueue.add(PageInfo(
        puuid: LolApi.instance.getAccountInfo()?.puuid ?? "",
      ));
      return pageInfoQueue[0];
    }
    return pageInfoQueue[currentPageInfoIndex];
  }

  bool get canBack => currentPageInfoIndex > 0;

  bool get canForward => currentPageInfoIndex < pageInfoQueue.length - 1;

  int? get currentGameId => currentPage?.currentGameId;

  GameInfo? get currentGameInfo => currentPage?.currentGameInfo;

  List<Player> get team1 => currentPage?.currentGameInfo?.team1 ?? [];

  List<Player> get team2 => currentPage?.currentGameInfo?.team2 ?? [];

  int get winTeam => currentPage?.currentGameInfo?.winTeam ?? 0;

  int get matchHistoryCount => currentPage?.historyInfoList?.length ?? 0;

  String? get currentUserName {
    return currentPage?.userName;
  }

  void open(String? puuid, int pageIndex) {
    if (puuid == null) {
      return;
    }
    // 1.清空后面的前进
    if (pageInfoQueue.length > currentPageInfoIndex + 1) {
      pageInfoQueue.removeRange(currentPageInfoIndex + 1, pageInfoQueue.length);
    }
    // 2.添加初始化数据
    pageInfoQueue.add(PageInfo(
      puuid: puuid,
      pageIndex: pageIndex,
    ));
    currentPageInfoIndex++;
    // 3.刷新页面
    fetchData();
  }

  // 后退
  void back() {
    if (canBack) {
      currentPageInfoIndex--;
      notifyListeners();
    }
  }

  // 前进
  void forward() {
    if (canForward) {
      currentPageInfoIndex++;
      notifyListeners();
    }
  }

  // 刷新
  Future<void> fetchData() async {
    await getMatchHistory();
    await getMatchDetail();
    // 将数据记录到 gameRecord
    var historyList = currentPage?.historyInfoList;
    await StatisticStandardService.instance.recordGameInfo(historyList);
    notifyListeners();
  }

  // 刷新
  Future<void> refresh() async {
    currentPage?.historyInfoList = null;
    await fetchData();
  }

  // 如果用户id更新了，则刷新
  Future<void> refreshOnClientUpdateStatus() async {
    if (pageInfoQueue.isEmpty) {
      await refresh();
      return;
    }
    var currentClientId = pageInfoQueue.first.userName;
    if (currentClientId != LolApi.instance.getAccountInfo()?.gameName) {
      await refresh();
    }
  }

  // 获取战绩列表
  Future<void> getMatchHistory() async {
    loadingList = true;
    notifyListeners();
    try {
      if (currentPage?.historyInfoList != null) {
        return;
      }
      // 战绩列表 data[games][games]
      // 只查5v5的对局: 峡谷模式mapId:11,排位gameType：MATCHED_GAME
      // 需要heroId、gameId、游戏类型(11是排位)、游戏日期、胜利与否
      var historyList = await LolApi.instance
          .queryMatchHistory(currentPage?.puuid, currentPage?.pageIndex ?? 0);
      if (historyList == null || historyList["games"] == null) {
        return;
      }
      var games = historyList["games"]["games"];
      var historyInfoList = <HistoryInfo>[];
      for (var item in games) {
        var heroId = item["participants"].first["championId"];
        var heroIcon =
            await HeroService.instance.getHeroIcon(heroId?.toString());
        var summonerId =
            item["participantIdentities"].first["player"]["summonerId"];
        var userName =
            item["participantIdentities"].first["player"]["gameName"];
        var gameId = item["gameId"];
        var gameType = item["gameType"];
        var mapId = item["mapId"];
        // 2024-06-20T12:57:56.218Z
        var gameDate =
            MyDateUtils.formatUtcDateToDateTime(item["gameCreationDate"]);
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
        historyInfoList.add(historyInfo);
      }
      currentPage?.historyInfoList = historyInfoList;
      currentPage?.currentGameId = historyInfoList.first.gameId;
      currentPage?.userName = historyInfoList.first.userName;
    } finally {
      loadingList = false;
      notifyListeners();
    }
  }

  // 获取战绩详情
  Future<void> getMatchDetail() async {
    // 战绩详情
    loadingDetail = true;
    notifyListeners();
    try {
      var gameId = currentPage?.currentGameId;
      if (gameId == null) {
        return;
      }
      if (currentPage?.gameInfoMap.containsKey(gameId.toString()) == true) {
        currentPage?.currentGameInfo =
            currentPage?.gameInfoMap[gameId.toString()];
        return;
      }
      var json = await LolApi.instance.queryGameDetailInfo(gameId);
      if (json == null) {
        return;
      }
      var gameInfo = GameInfo();
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
        var rankInfo = await LolApi.instance.queryRankInfo(player.puuid);
        if (rankInfo != null) {
          player.rankLevel1 = getRankLevel1Str(
              rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["tier"]);
          player.rankLevel2 = getRankLevel2Str(
              rankInfo["queueMap"]?["RANKED_SOLO_5x5"]?["division"]);
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
      }
      gameInfo.team1 = teams["100"];
      gameInfo.team2 = teams["200"];
      gameInfo.winTeam = (teams["100"]?.first.win == true) ? 1 : 2;
      currentPage?.currentGameInfo = gameInfo;
      currentPage?.gameInfoMap[gameId.toString()] = gameInfo;
    } finally {
      loadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> changeGameId(int? gameId) async {
    currentPage?.currentGameId = gameId;
    await getMatchDetail();
  }

  String? getRankLevel1Str(String? rankInfo) {
    switch (rankInfo) {
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
        return rankInfo;
    }
  }

  String getRankLevel2Str(String? level) {
    if (level == null || level == "NA") {
      return "未定级";
    }
    return level;
  }

  bool get canToPreviousPage {
    var currentIndex = currentPage?.pageIndex ?? 0;
    return currentIndex > 0;
  }

  void toPreviousPage() {
    if (!canToPreviousPage) {
      return;
    }
    var currentIndex = currentPage?.pageIndex ?? 0;
    open(currentPage?.puuid, currentIndex - 1);
  }

  bool get canToNextPage {
    return true;
  }

  void toNextPage() {
    if (!canToNextPage) {
      return;
    }
    var currentIndex = currentPage?.pageIndex ?? 0;
    open(currentPage?.puuid, currentIndex + 1);
  }

  Future<void> searchSummoner(String value) async {
    var split = value.split("#");
    var puuid = await LolApi.instance.queryPuuidByAlias(split[0], split[1]);
    if (puuid == null) {
      return;
    }
    open(puuid, 0);
  }
}
