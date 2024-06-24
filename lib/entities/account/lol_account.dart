class LolAccountInfo {
  int? accountId;

  String? displayName;

  String? gameName;

  String? internalName;

  bool? nameChangeFlag;

  int? percentCompleteForNextLevel;

  String? privacy;

  int? profileIconId;

  String? puuid;

  int? summonerId;

  int? summonerLevel;

  String? tagLine;

  bool? unnamed;

  int? xpSinceLastLevel;

  int? xpUntilNextLevel;

  LolAccountInfo({
    this.accountId,
    this.displayName,
    this.gameName,
    this.internalName,
    this.nameChangeFlag,
    this.percentCompleteForNextLevel,
    this.privacy,
    this.profileIconId,
    this.puuid,
    this.summonerId,
    this.summonerLevel,
    this.tagLine,
    this.unnamed,
    this.xpSinceLastLevel,
    this.xpUntilNextLevel,
  });

  factory LolAccountInfo.fromJson(Map<String, dynamic> json) {
    return LolAccountInfo(
      accountId: json['accountId'],
      displayName: json['displayName'],
      gameName: json['gameName'],
      internalName: json['internalName'] == null ? null : json['internalName'],
      nameChangeFlag: json['nameChangeFlag'],
      percentCompleteForNextLevel: json['percentCompleteForNextLevel'],
      privacy: json['privacy'],
      profileIconId: json['profileIconId'],
      puuid: json['puuid'],
      summonerId: json['summonerId'],
      summonerLevel: json['summonerLevel'],
      tagLine: json['tagLine'],
      unnamed: json['unnamed'],
      xpSinceLastLevel: json['xpSinceLastLevel'],
      xpUntilNextLevel: json['xpUntilNextLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'displayName': displayName,
      'gameName': gameName,
      'internalName': internalName,
      'nameChangeFlag': nameChangeFlag,
      'percentCompleteForNextLevel': percentCompleteForNextLevel,
      'privacy': privacy,
      'profileIconId': profileIconId,
      'puuid': puuid,
      'summonerId': summonerId,
      'summonerLevel': summonerLevel,
      'tagLine': tagLine,
      'unnamed': unnamed,
      'xpSinceLastLevel': xpSinceLastLevel,
      'xpUntilNextLevel': xpUntilNextLevel,
    };
  }
}
