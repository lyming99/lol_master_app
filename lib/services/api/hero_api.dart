import 'package:lol_master_app/entities/hero/hero_spell.dart';

abstract class HeroApi {
  Future<List<HeroSpell>?> queryHeroSpells(String id);
}
