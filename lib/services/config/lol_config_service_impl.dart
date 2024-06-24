import 'package:lol_master_app/dao/config/lol_config_dao.dart';
import 'package:lol_master_app/entities/config/lol_config.dart';
import 'package:lol_master_app/services/config/lol_config_service.dart';

class LolConfigServiceImpl extends LolConfigService {
  @override
  Future<LolConfig?> getCurrentConfig() async {
    return LolConfigDao.instance.getCurrentConfig();
  }

  @override
  Future<void> updateCurrentConfig(LolConfig? lolConfig) async {
    await LolConfigDao.instance.updateCurrentConfig(lolConfig);
  }
}
