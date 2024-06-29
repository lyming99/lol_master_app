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

class PageInfo {
  String puuid;

  var pageIndex = 0;

  // 用户点击的当前游戏id
  int? currentGameId;

  String? userName;

  GameInfo? currentGameInfo;

  List<HistoryInfo>? historyInfoList;

  Map<String, GameInfo> gameInfoMap = {};

  PageInfo({
    required this.puuid,
    this.pageIndex = 0,
  });

  String get pageIndexStr => (pageIndex + 1).toString();
}

// 需要heroId、gameId、游戏类型(11是排位)、游戏日期、胜利与否
class HistoryInfo {
  int? summonerId;
  String? userName;
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

  Player? currentPlayer;

  HistoryInfo({
    this.userName,
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

  String getGameTypeStr() {
    if (gameType == "CUSTOM_GAME") {
      return "自定义";
    }

    /// 420  召唤师峡谷·排位赛 单排/双排·征召
    if (gameType == "MATCHED_GAME") {
      switch (queueId) {
        case 420:
          return "单双排";
        case 430:
          return "匹配";
        case 440:
          return "灵活排位";
        case 450:
          return "极地大乱斗";
        case 1700:
          return "斗魂竞技场";
      }
    }
    return "未知";
  }
}

class Player {
  String? heroId;
  String? heroIcon;
  String? userName;
  String? puuid;
  String? kda;

  // kda:k
  int? kills;

  // kda:d
  int? deaths;

  // kda:a
  int? assists;

  // 段位
  String? rankLevel1;

  // 小段位
  String? rankLevel2;

  //stats."perkPrimaryStyle": 8000,
  //stats."perkSubStyle": 8100,
  String? primaryRune;
  String? secondaryRune;
  String? primaryRuneIcon;
  String? secondaryRuneIcon;

  //"spell1Id": 11,
  //       "spell2Id": 4,
  String? spell1Id;
  String? spell1Icon;

  String? spell2Id;
  String? spell2Icon;
  String? item1;
  String? item2;
  String? item3;
  String? item4;
  String? item5;
  String? item6;
  String? item7;

  String? item1Icon;
  String? item2Icon;
  String? item3Icon;
  String? item4Icon;
  String? item5Icon;
  String? item6Icon;
  String? item7Icon;

  bool? win;

  String get rankLevel => rankLevel1 == null ? "" : "$rankLevel1$rankLevel2";

  // copy
  Player copy() {
    return Player()
      ..heroId = heroId
      ..heroIcon = heroIcon
      ..userName = userName
      ..puuid = puuid
      ..kda = kda
      ..kills = kills
      ..deaths = deaths
      ..assists = assists
      ..rankLevel1 = rankLevel1
      ..rankLevel2 = rankLevel2
      ..primaryRune = primaryRune
      ..secondaryRune = secondaryRune
      ..primaryRuneIcon = primaryRuneIcon
      ..secondaryRuneIcon = secondaryRuneIcon
      ..spell1Id = spell1Id
      ..spell1Icon = spell1Icon
      ..spell2Id = spell2Id
      ..spell2Icon = spell2Icon
      ..item1 = item1
      ..item2 = item2
      ..item3 = item3
      ..item4 = item4
      ..item5 = item5
      ..item6 = item6
      ..item7 = item7
      ..item1Icon = item1Icon
      ..item2Icon = item2Icon
      ..item3Icon = item3Icon
      ..item4Icon = item4Icon
      ..item5Icon = item5Icon
      ..item6Icon = item6Icon
      ..item7Icon = item7Icon
      ..win = win;
  }
}

/// 游戏信息
class GameInfo {
  int? winTeam;
  List<Player>? team1;
  List<Player>? team2;
  String? summonerName;
}
