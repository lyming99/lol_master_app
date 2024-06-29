import 'package:flutter/cupertino.dart';
import 'package:lol_master_app/entities/equip/equip_config.dart';
import 'package:lol_master_app/entities/lol/game_info.dart';
import 'package:lol_master_app/entities/rune/rune.dart';

import '../../entities/account/lol_account.dart';
import 'lol_api_impl.dart';

abstract class LolApi with ChangeNotifier {
  static LolApi? _instance;

  static LolApi get instance => _instance ??= LolApiImpl()
    ..startClientLoop()
    ..startGameStatusLoop();

  ValueNotifier<bool> state = ValueNotifier(false);
  List<List<HistoryInfo>>? myTeamHistoryInfo;
  List<List<HistoryInfo>>? otherTeamHistoryInfo;
  List<Player>? myTeamPlayers;
  List<Player>? otherTeamPlayers;
  /// 大哥大、大哥、小哥、小弟、坑比
  List<String>? userLevelList;

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

  Future<Map?> getGameSessionInfo();

  Future<String?> getCurrentSummonerPuuid();

  Future<Map?> queryMatchHistory(String? puuid, int pageIndex);

  Future<List<HistoryInfo>?> queryMatchHistoryInfo(
      String? puuid, int pageCount);

  Future<Map?> queryGameDetailInfo(int? gameId);

  Future<Map?> queryRankInfo(String? puuid);

  /// @deprecated 无法使用
  Future<List<String>> querySummonerIdList(String name);

  Future<String?> queryPuuidByAlias(String gameName, String tagLine);

  Future<dynamic> queryChatConversations();

  Future<dynamic> queryConversationMessages(String? conversationId);

  Future<dynamic> queryGameSession();

  Future<dynamic> querySummonerInfoByPuuid(String puuid);
}
