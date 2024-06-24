import 'package:flutter/material.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/hero/hero_service.dart';
import 'package:lol_master_app/util/mvc.dart';

class PageInfo {
  String? puuid;
  int beginIndex = 0;
  int endIndex = 10;

  // 用户点击的当前游戏id
  int? currentGameId;

  List<HistoryInfo>? historyInfoList;

  PageInfo({
    this.puuid,
    required this.beginIndex,
    required this.endIndex,
  });
}

// 需要heroId、gameId、游戏类型(11是排位)、游戏日期、胜利与否
class HistoryInfo {
  int? summonerId;
  String? heroId;
  String? heroIcon;
  int? gameId;
  int? mapId;

  // 模式：排位、匹配、人机
  String? gameType;
  String? gameDate;
  int? gameDuration;
  bool? gameResult;

  int? queueId;

  HistoryInfo({
    this.summonerId,
    this.heroId,
    this.heroIcon,
    this.mapId,
    this.gameId,
    this.gameType,
    this.gameDate,
    this.gameDuration,
    this.gameResult,
    this.queueId,
  });
}

/// 1.查询战绩列表(待优化：召唤师名称显示)
/// 2.查询战绩详情(待优化：战绩title显示)
/// 3.刷新列表按钮
class DeskMatchHistoryController extends MvcController {
  // 前进后退栈
  List<PageInfo> pageInfoQueue = [];
  int currentPageInfoIndex = 0;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    fetchData();
  }

  PageInfo get currentPage {
    // 重置
    if (pageInfoQueue.isEmpty) {
      currentPageInfoIndex = 0;
      pageInfoQueue.add(PageInfo(beginIndex: 0, endIndex: 10));
    }
    return pageInfoQueue.elementAt(currentPageInfoIndex);
  }

  bool get canBack => currentPageInfoIndex > 0;

  bool get canForward => currentPageInfoIndex < pageInfoQueue.length - 1;

  int? get currentGameId => currentPage.currentGameId;

  void open(String puuid, int beginIndex, int endIndex) {
    // 1.清空后面的前进
    if (pageInfoQueue.length > currentPageInfoIndex + 1) {
      pageInfoQueue.removeRange(currentPageInfoIndex + 1, pageInfoQueue.length);
    }
    // 2.添加初始化数据
    pageInfoQueue.add(PageInfo(
      puuid: puuid,
      beginIndex: beginIndex,
      endIndex: endIndex,
    ));
    currentPageInfoIndex++;
    // 3.刷新页面
    notifyListeners();
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
    notifyListeners();
  }

  // 刷新
  Future<void> refresh() async {
    currentPage.historyInfoList = null;
    await fetchData();
  }

  // 获取战绩列表
  Future<void> getMatchHistory() async {
    if (currentPage.historyInfoList != null) {
      return;
    }
    // 战绩列表 data[games][games]
    // 只查5v5的对局: 峡谷模式mapId:11,排位gameType：MATCHED_GAME
    // 需要heroId、gameId、游戏类型(11是排位)、游戏日期、胜利与否
    var historyList =
        await LolApi.instance.queryMatchHistory(currentPage.puuid);
    if (historyList == null || historyList["games"] == null) {
      return;
    }
    var games = historyList["games"]["games"];
    var historyInfoList = <HistoryInfo>[];
    for (var item in games) {
      var heroId = item["participants"].first["championId"];
      var heroIcon = await HeroService.instance.getHeroIcon(heroId?.toString());
      var summonerId =
          item["participantIdentities"].first["player"]["summonerId"];
      var gameId = item["gameId"];
      var gameType = item["gameType"];
      var mapId = item["mapId"];
      // 2024-06-20T12:57:56.218Z
      var gameDate = item["gameCreationDate"];
      var gameDuration = item["gameDuration"];
      var gameResult = item["participants"].first["stats"]["win"];
      var queueId = item["queueId"];
      var historyInfo = HistoryInfo(
        summonerId: summonerId,
        heroId: heroId?.toString(),
        heroIcon: heroIcon,
        gameId: gameId,
        gameType: gameType,
        mapId: mapId,
        gameDate: gameDate?.toString().substring(5, 10),
        gameDuration: gameDuration,
        gameResult: gameResult,
        queueId: queueId,
      );
      historyInfoList.add(historyInfo);
    }
    currentPage.historyInfoList = historyInfoList;
  }

  // 获取战绩详情
  Future<void> getMatchDetail() async {
    // 战绩详情
    // var gameDetailInfo =
    //     await LolApi.instance.queryGameDetailInfo(currentPage.currentGameId);
  }

  int get matchHistoryCount => currentPage.historyInfoList?.length ?? 0;

  void changeGameId(int? gameId) {
    currentPage.currentGameId = gameId;
    notifyListeners();
  }
}
