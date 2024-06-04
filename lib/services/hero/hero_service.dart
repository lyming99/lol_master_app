import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/entities/hero/hero_spell.dart';

abstract class HeroService {
  /// 获取英雄列表
  Future<List<HeroInfo>> getHeroList();

  /// 收藏英雄
  Future<bool> favoriteHero(HeroInfo hero);

  Future<List<HeroSpell>> getHeroSpell(String id);
}
