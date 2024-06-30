/// 标准管理分组
class StatisticStandardGroup {
  int? id;
  String? uuid;
  String? name;
  int? createTime;
  int? updateTime;
}

/// 评分标准项目
class StatisticStandardItem {
  int? id;

  String? uuid;

  /// 分组id
  String? groupId;

  /// 评分名称
  String? name;

  /// 评分类型：整数型、选项型、布尔型
  String? type;

  /// 选项型列表
  String? items;

  int? createTime;

  int? updateTime;
}

/// 评分记录
class StatisticStandardRecord {
  int? id;

  String? uuid;

  /// 标准id
  String? standardItemId;

  /// 评分值
  String? value;

  int? createTime;

  int? updateTime;
}