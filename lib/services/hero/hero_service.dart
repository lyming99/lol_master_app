import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/entities/hero/hero_spell.dart';
import 'package:lol_master_app/services/hero/hero_service_impl.dart';

abstract class HeroService {
  static HeroService? _instance;

  static HeroService get instance => _instance ??= HeroServiceImpl();

  /// 获取英雄列表
  Future<List<HeroInfo>> getHeroList();

  /// 收藏英雄
  Future<bool> favoriteHero(HeroInfo hero);

  Future<List<HeroSpell>> getHeroSpell(String id);

  Future<String?> getHeroIcon(String? heroId);

  Future<HeroInfo?> getHeroInfo(String? heroId);
}
