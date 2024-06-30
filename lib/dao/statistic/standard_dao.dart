import 'package:lol_master_app/dao/base_dao.dart';

import '../../entities/rune/rune.dart';
import '../db_factory.dart';
import 'standard_dao_impl.dart';

abstract class StandardDao extends BaseDao {
  static StandardDao get instance =>
      StandardDaoImpl(database: MyDbFactory.instance.database);

  StandardDao({required super.database});


}
