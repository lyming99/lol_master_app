/// 标准管理分组
class StatisticStandardGroup {
  int? id;
  String? uuid;

  /// 用户的 puuid
  String? puuid;

  String? summonerId;

  String? name;
  int? createTime;
  int? updateTime;
  bool? selected;

  List<StatisticStandardItem> items = [];

  StatisticStandardGroup({
    this.id,
    this.uuid,
    this.puuid,
    this.summonerId,
    this.name,
    this.createTime,
    this.updateTime,
    this.selected,
  });

  factory StatisticStandardGroup.fromJson(Map<String, dynamic> json) {
    return StatisticStandardGroup(
      id: json['id'],
      uuid: json['uuid'],
      puuid: json['puuid'],
      summonerId: json['summonerId'],
      name: json['name'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      selected: json['selected'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'puuid': puuid,
      'summonerId': summonerId,
      'name': name,
      'createTime': createTime,
      'updateTime': updateTime,
      'selected': selected == true ? 1 : 0,
    };
  }
}

/// 评分标准项目
class StatisticStandardItem {
  int? id;

  String? uuid;

  /// 用户的 puuid
  String? puuid;

  String? summonerId;

  /// 分组id
  int? groupId;

  /// 评分名称
  String? name;

  /// 评分类型：整数型、选项型、布尔型
  String? type;

  /// 选项型列表
  String? items;

  int? createTime;

  int? updateTime;

  StatisticStandardItem({
    this.id,
    this.uuid,
    this.puuid,
    this.summonerId,
    this.groupId,
    this.name,
    this.type,
    this.items,
    this.createTime,
    this.updateTime,
  });

  factory StatisticStandardItem.fromJson(Map<String, dynamic> json) {
    return StatisticStandardItem(
      id: json['id'],
      uuid: json['uuid'],
      puuid: json['puuid'],
      summonerId: json['summonerId'],
      groupId: json['groupId'],
      name: json['name'],
      type: json['type'],
      items: json['items'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'puuid': puuid,
      'summonerId': summonerId,
      'groupId': groupId,
      'name': name,
      'type': type,
      'items': items,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}

/// 评分记录
class StatisticStandardRecord {
  int? id;

  String? uuid;

  /// 用户的 puuid
  String? puuid;

  String? summonerId;

  /// 游戏id
  String? gameId;

  /// 标准id
  int? standardItemId;

  /// 评分值
  String? value;

  int? createTime;

  int? updateTime;

  StatisticStandardRecord({
    this.id,
    this.uuid,
    this.puuid,
    this.summonerId,
    this.gameId,
    this.standardItemId,
    this.value,
    this.createTime,
    this.updateTime,
  });

  factory StatisticStandardRecord.fromJson(Map<String, dynamic> json) {
    return StatisticStandardRecord(
      id: json['id'],
      uuid: json['uuid'],
      puuid: json['puuid'],
      summonerId: json['summonerId'],
      gameId: json['gameId'],
      standardItemId: json['standardItemId'],
      value: json['value'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'puuid': puuid,
      'summonerId': summonerId,
      'gameId': gameId,
      'standardItemId': standardItemId,
      'value': value,
      'createTime': createTime,
      'updateTime': updateTime,
    };
  }
}
