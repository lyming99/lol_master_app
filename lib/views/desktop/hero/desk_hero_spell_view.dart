import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/hero/desk_hero_spell_controller.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/label_title_widget.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// 英雄技能视图
class DeskHeroSpellView extends MvcView<DeskHeroSpellController> {
  const DeskHeroSpellView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Container(
            constraints: const BoxConstraints(
              maxWidth: 360,
            ),
            child: LabelTitleWidget(
              title: "英雄技能",
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          // 技能图标
          Wrap(
            children: [
              for (var i = 0; i < controller.spells.length; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.selectSkill(i);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.all(3),
                            color: controller.selectSkillIndex == i
                                ? Colors.red
                                : Colors.grey.shade200,
                            child: Image.network(
                                controller.spells[i].abilityIconPath ?? ""),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(controller.spells[i].spellKey ?? ""),
                    ],
                  ),
                ),
            ],
          ),
          // 技能介绍和技能视频
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.selectedSpell?.abilityVideoPath != null &&
                  controller.selectedSpell?.abilityVideoPath != "")
                _SkillVideoWidget(controller, true, min(480, cons.maxWidth)),
              SizedBox(
                height: 16,
              ),

              _SkillDescWidget(controller, true, cons.maxWidth),
              const SizedBox(height: 16),
            ],
          ),
        ],
      );
    });
  }
}

// 技能介绍
class _SkillDescWidget extends StatelessWidget {
  final DeskHeroSpellController controller;
  final bool fillContent;
  final double maxWidth;

  const _SkillDescWidget(this.controller, this.fillContent, this.maxWidth);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.selectedSpell?.name ?? "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(controller.selectedSpell?.description ?? ""),
      ],
    );
  }
}

// 技能视频
class _SkillVideoWidget extends StatelessWidget {
  final DeskHeroSpellController controller;
  final bool fillContent;
  final double maxWidth;

  const _SkillVideoWidget(this.controller, this.fillContent, this.maxWidth);

  @override
  Widget build(BuildContext context) {
    return _VideoPlayer(
      videoUrl: controller.selectedSpell?.abilityVideoPath,
      maxWidth: maxWidth,
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  final String? videoUrl;
  final double maxWidth;

  const _VideoPlayer({super.key, this.videoUrl, required this.maxWidth});

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() {
    var videoUrl = widget.videoUrl;
    if (videoUrl != null) {
      player.open(
        Media(videoUrl),
      );
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _VideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      loadVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: widget.maxWidth * 9.0 / 13.2,
      child: Video(controller: controller),
    );
  }
}
