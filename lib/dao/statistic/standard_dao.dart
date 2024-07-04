import 'package:lol_master_app/dao/base_dao.dart';
import 'package:lol_master_app/entities/statistic/game_record.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';

import '../db_factory.dart';
import 'standard_dao_impl.dart';

/// 标准管理
///
abstract class StandardDao extends BaseDao {
  static StandardDao get instance =>
      StandardDaoImpl(database: MyDbFactory.instance.database);

  StandardDao({required super.database});

  Future<int> deleteStandardRecord(StatisticStandardRecord record);

  Future<List<StatisticStandardGroup>> getStandardGroupList();

  Future<List<StatisticStandardItem>> getStandardItemList(int? groupId);

  Future<List<StatisticStandardRecord>> getStandardRecordList(String itemId);

  Future<List<StatisticStandardRecord>> getStandardRecordListByGameId(
      String gameId);

  Future<int> upsertStandardRecord(StatisticStandardRecord record);

  Future<int> deleteStandardGroup(int? groupId);

  Future<int> addStandardGroup(StatisticStandardGroup group);

  Future<int> updateStandardGroup(StatisticStandardGroup group);

  Future<int> deleteStandardItem(int? id);

  Future<int> updateStandardItem(StatisticStandardItem item);

  Future<int> addStandardItem(StatisticStandardItem item);

  Future<int> upsertGameRecord(GameRecord item);

  Future<List<GameRecord>> getGameRecordList();
}
