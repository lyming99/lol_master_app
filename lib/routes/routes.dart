import 'package:go_router/go_router.dart';
import 'package:lol_master_app/controllers/desktop/desk_home.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_detail_controller.dart';
import 'package:lol_master_app/controllers/desktop/rune/desk_rune_config_controller.dart';
import 'package:lol_master_app/entities/hero/hero_info.dart';
import 'package:lol_master_app/views/desktop/desk_home_view.dart';
import 'package:lol_master_app/views/desktop/hero/desk_hero_detail_view.dart';
import 'package:lol_master_app/views/desktop/rune/desk_rune_config_view.dart';

final deskRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) {
        return DeskHomeView(controller: DeskHomeController());
      },
    ),
    GoRoute(
      path: "/hero/detail",
      builder: (context, state) {
        var controller = DeskHeroDetailController();
        var extra = state.extra;
        if (extra is HeroInfo) {
          controller.hero = extra;
        }
        return DeskHeroDetailView(controller: controller);
      },
    ),
    GoRoute(
      path: "/test",
      builder: (context, state) {
        return DeskRuneConfigView(
          controller: DeskRuneConfigController(
            config: RuneConfigs(
              primaryRunes: [],
              secondaryRunes: [],
              thirdRunes: [],
              primaryRuneKey: "",
              secondaryRuneKey: "",
            ),
          ),
        );
      },
    ),
  ],
);
