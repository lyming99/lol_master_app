import 'package:flutter/cupertino.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/rune/rune.dart';

import '../../entities/account/lol_account.dart';
import 'lol_api_impl.dart';

abstract class LolApi with ChangeNotifier {
  static LolApi? _instance;

  static LolApi get instance =>
      _instance ??= LolApiImpl()
        ..startClientLoop()
        ..startGameStatusLoop();

  ValueNotifier<bool> state = ValueNotifier(false);

  @override
  void notifyListeners() {
    super.notifyListeners();
    state.notifyListeners();
  }

  void startClientLoop();

  void startGameStatusLoop();

  Future<bool> isClientRunning();

  Future<void> readClientInfo();

  Future<String?> getCurrentRuneId();

  Future<void> putRune(RuneConfig config);

  Future<int?> getCurrentSummonerId();

  Future<dynamic> getEquipConfig();

  Future<dynamic> putEquipConfig(EquipConfig content);

  LolAccountInfo? getAccountInfo();

  bool hasLogin();

  String getAccountIcon();

  Future<GameStatusEnum?> getGameStatus();

  Future<void> acceptGame();

  Future<void> selectChamp();

  Future<Map?> getChampSelectInfo();

  Future<String?> getCurrentSummonerPuuid();

  Future<Map?> queryMatchHistory();

  Future<Map?> queryGameDetailInfo(String? gameId);
}
