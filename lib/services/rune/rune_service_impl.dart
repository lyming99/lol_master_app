import 'package:lol_master_app/dao/rune/rune_dao.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/services/api/lol_api_impl.dart';
import 'package:lol_master_app/services/rune/rune_service.dart';

class RuneServiceImpl extends RuneService {
  RuneDao runeDao = RuneDao.instance;

  @override
  Future<void> addRuneConfig(RuneConfig runeConfig) async {
    runeDao.addRuneConfig(runeConfig);
  }

  @override
  Future<void> deleteRuneConfig(RuneConfig runeConfig) async {
    runeDao.deleteRuneConfig(runeConfig);
  }

  @override
  Future<List<RuneConfig>> getRuneConfigList(String heroId) async {
    return runeDao.getRuneConfigList(heroId);
  }

  @override
  Future<void> updateRuneConfig(RuneConfig runeConfig) async {
    if (runeConfig.id != null && runeConfig.id != -1) {
      await runeDao.updateRuneConfig(runeConfig);
    } else {
      await addRuneConfig(runeConfig);
    }
  }

  /// 应用符文到LOL客户端
  Future<void> applyToLolClient(RuneConfig runeConfig) async {
    /// 1.读取客户端的key
    /// 2.将配置发送给客户端
    await LolApi.instance.putRune(runeConfig);
  }
}
