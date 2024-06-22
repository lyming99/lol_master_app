import 'package:lol_master_app/entities/rune/rune.dart';

abstract class LolApi {
  Future<void> readClientInfo();

  Future<String?> getCurrentRuneId();

  Future<void> putRune(RuneConfig config);
}
