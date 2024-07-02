import 'package:lol_master_app/entities/statistic/statistic_standard.dart';

import 'statistic_standard_service_impl.dart';
/// 评分标准系统管理Service
abstract class StatisticStandardService {
  static StatisticStandardService? _instance;

  static StatisticStandardService get instance =>
      _instance ??= StatisticStandardServiceImpl();

  /// 查询评分标准分组列表
  Future<List<StatisticStandardGroup>> getStandardGroupList([bool queryItem = false]);

  /// 查询评分标准项目列表
  Future<List<StatisticStandardItem>> getStandardItemList(int groupId);

  /// 查询评分标准记录列表
  Future<List<StatisticStandardRecord>> getStandardRecordList(String itemId);

  /// 添加评分标准记录
  Future<void> addStandardRecord(StatisticStandardRecord record);

  /// 删除评分标准记录
  Future<void> deleteStandardRecord(StatisticStandardRecord record);

  /// 更新评分标准记录
  Future<void> updateStandardRecord(StatisticStandardRecord record);

  Future<void> save(List<StatisticStandardGroup> groupList);

  Future<void> deleteGroup(int? id);
}
