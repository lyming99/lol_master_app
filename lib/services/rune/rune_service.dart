import '../../entities/rune/rune.dart';
import 'rune_service_impl.dart';

abstract class RuneService {
  static RuneService? _instance;

  static RuneService get instance => _instance ??= RuneServiceImpl();

  Future<void> deleteRuneConfig(RuneConfig runeConfig);

  Future<void> addRuneConfig(RuneConfig runeConfig);

  Future<void> updateRuneConfig(RuneConfig runeConfig);

  Future<List<RuneConfig>> getRuneConfigList(String heroId);

  Future<String?> getRuneIcon(String? runeId);

  Future<String?> getSummonerSpell(String? spellId);
}
