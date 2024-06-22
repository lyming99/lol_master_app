import '../../entities/rune/rune.dart';

abstract class RuneService{
  Future<void> deleteRuneConfig(RuneConfig runeConfig);
  Future<void> addRuneConfig(RuneConfig runeConfig);
  Future<void> updateRuneConfig(RuneConfig runeConfig);
  Future<List<RuneConfig>> getRuneConfigList(String heroId);
}