import '../../entities/config/lol_config.dart';
import '../base_dao.dart';
import '../db_factory.dart';
import 'lol_config_dao_impl.dart';

abstract class LolConfigDao extends BaseDao {
  static LolConfigDao get instance =>
      LolConfigDaoImpl(database: MyDbFactory.instance.database);

  LolConfigDao({required super.database});

  Future<LolConfig?> getCurrentConfig();

  Future<int?> updateCurrentConfig(LolConfig? lolConfig);
}
