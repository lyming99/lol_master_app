import 'package:lol_master_app/dao/base_dao.dart';

import '../../entities/rune/rune.dart';
import '../db_factory.dart';
import 'rune_dao_impl.dart';

abstract class RuneDao extends BaseDao {
  static RuneDao get instance =>
      RuneDaoImpl(database: MyDbFactory.instance.database);

  RuneDao({required super.database});

  Future<int?> addRuneConfig(RuneConfig runeConfig);

  Future<int?> updateRuneConfig(RuneConfig runeConfig);

  Future<void> deleteRuneConfig(RuneConfig runeConfig);

  Future<List<RuneConfig>> getRuneConfigList(String heroId);
}
