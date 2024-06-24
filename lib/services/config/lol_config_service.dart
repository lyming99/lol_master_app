import 'package:lol_master_app/entities/config/lol_config.dart';

import 'lol_config_service_impl.dart';

abstract class LolConfigService {
  static LolConfigService? _instance;

  static LolConfigService get instance => _instance ??= LolConfigServiceImpl();

  Future<LolConfig?> getCurrentConfig();

  Future<void> updateCurrentConfig(LolConfig? lolConfig);
}
