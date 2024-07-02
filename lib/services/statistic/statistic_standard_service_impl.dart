import 'package:lol_master_app/dao/statistic/standard_dao.dart';
import 'package:lol_master_app/entities/statistic/statistic_standard.dart';

import 'statistic_standard_service.dart';

class StatisticStandardServiceImpl extends StatisticStandardService {
  @override
  Future<void> addStandardRecord(StatisticStandardRecord record) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStandardRecord(StatisticStandardRecord record) async {
    StandardDao.instance.deleteStandardRecord(record);
  }

  @override
  Future<void> deleteGroup(int? id) {
    return StandardDao.instance.deleteStandardGroup(id);
  }

  @override
  Future<List<StatisticStandardGroup>> getStandardGroupList(
      [bool queryItem = false]) async {
    var resp = await StandardDao.instance.getStandardGroupList();
    if (queryItem) {
      for (var value in resp) {
        var items = await getStandardItemList(value.id);
        value.items = items;
      }
    }
    return resp;
  }

  @override
  Future<List<StatisticStandardItem>> getStandardItemList(int? groupId) async {
    var resp = await StandardDao.instance.getStandardItemList(groupId);
    return resp;
  }

  @override
  Future<List<StatisticStandardRecord>> getStandardRecordList(
      String itemId) async {
    var resp = await StandardDao.instance.getStandardRecordList();
    return resp;
  }

  @override
  Future<void> updateStandardRecord(StatisticStandardRecord record) async {
    await StandardDao.instance.updateStandardRecord(record);
  }

  Future<void> deleteGroupSet(List<StatisticStandardGroup> groupList) async {
    var tableGroupList = await getStandardGroupList();
    var oldIdSet = tableGroupList.map((e) => e.id).toSet();
    var newIdSet = groupList.map((e) => e.id).toSet();
    var deleteIdSet = oldIdSet.difference(newIdSet);
    for (var id in deleteIdSet) {
      await StandardDao.instance.deleteStandardGroup(id);
    }
  }

  Future<void> deleteItemSet(
      int? groupId, List<StatisticStandardItem> itemList) async {
    var tableItemList = await getStandardItemList(groupId);
    var oldIdSet = tableItemList.map((e) => e.id).toSet();
    var newIdSet = itemList.map((e) => e.id).toSet();
    var deleteIdSet = oldIdSet.difference(newIdSet);
    for (var id in deleteIdSet) {
      await StandardDao.instance.deleteStandardItem(id);
    }
  }

  @override
  Future<void> save(List<StatisticStandardGroup> groupList) async {
    await deleteGroupSet(groupList);

    /// 保存所有配置
    /// 1.删除已经删除的配置项目
    for (var group in groupList) {
      if (group.id != null) {
        /// 删除已经删除的配置项目
        await StandardDao.instance.updateStandardGroup(group);
      } else {
        /// 保存新增的配置项目
        await StandardDao.instance.addStandardGroup(group);
      }
      await deleteItemSet(group.id, group.items);
      for (var item in group.items) {
        if (item.id != null) {
          // 更新
          await StandardDao.instance.updateStandardItem(item);
        } else {
          // 写入
          await StandardDao.instance.addStandardItem(item);
        }
      }
    }
  }
}
