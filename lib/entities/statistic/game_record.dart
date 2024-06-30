/// 1.查询游戏记录数据
/// 2.对局结束触发查询
/// 3.登录触发查询
class GameRecord {
  int? id;

  String? puuid;

  /// lol官方接口游戏id
  String? gameId;

  /// 单双排，匹配：我们只统计排位数据
  String? gameType;

  /// 游戏开始时间：时间戳(秒)
  int? gameTime;

  /// 游戏时长：秒
  int? gameDuration;

  /// 输出伤害
  int? totalDamageDealtToChampions;

  /// 输出伤害占比
  double? totalDamageDealtToChampionsPercent;

  /// 承受伤害
  int? totalDamageTaken;

  /// 承受伤害占比
  double? totalDamageTakenPercent;

  /// kda:k
  int? kills;

  /// kda:d
  int? deaths;

  /// kda:a
  int? assists;

  /// 大段位
  String? rankLevel1;

  /// 小段位
  String? rankLevel2;

  /// 补刀数量
  int? creepScore;

  /// 装备列表
  String? items;

  /// 上单、中单、下路、打野、辅助
  String? position;

  /// 召唤师技能1
  String? spell1;

  /// 召唤师技能2
  String? spell2;

  /// 符文1
  String? primaryRune;

  /// 符文2
  String? secondaryRune;

  GameRecord({
    this.gameId,
    this.gameType,
    this.gameTime,
    this.gameDuration,
    this.totalDamageDealtToChampions,
    this.totalDamageDealtToChampionsPercent,
    this.totalDamageTaken,
    this.totalDamageTakenPercent,
    this.kills,
    this.deaths,
    this.assists,
    this.rankLevel1,
    this.rankLevel2,
    this.creepScore,
    this.items,
    this.position,
    this.spell1,
    this.spell2,
    this.primaryRune,
    this.secondaryRune,
  });

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    return GameRecord(
      gameId: json['gameId'],
      gameType: json['gameType'],
      gameTime: json['gameTime'],
      gameDuration: json['gameDuration'],
      totalDamageDealtToChampions: json['totalDamageDealtToChampions'],
      totalDamageDealtToChampionsPercent:
          json['totalDamageDealtToChampionsPercent'],
      totalDamageTaken: json['totalDamageTaken'],
      totalDamageTakenPercent: json['totalDamageTakenPercent'],
      kills: json['kills'],
      deaths: json['deaths'],
      assists: json['assists'],
      rankLevel1: json['rankLevel1'],
      rankLevel2: json['rankLevel2'],
      creepScore: json['creepScore'],
      items: json['items'],
      position: json['position'],
      spell1: json['spell1'],
      spell2: json['spell2'],
      primaryRune: json['primaryRune'],
      secondaryRune: json['secondaryRune'],
    );
  }
}
