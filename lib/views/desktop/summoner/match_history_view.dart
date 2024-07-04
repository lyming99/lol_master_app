import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/summoner/match_history_controller.dart';
import 'package:lol_master_app/entities/lol/game_info.dart';
import 'package:lol_master_app/util/mvc.dart';

import 'horizontal_button_widget.dart';

class DeskMatchHistoryView extends MvcView<DeskMatchHistoryController> {
  const DeskMatchHistoryView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                width: 300,
                constraints: const BoxConstraints(maxHeight: 36),
                margin: const EdgeInsets.only(left: 4),
                child: TextField(
                  // controller: controller.searchController,
                  decoration: const InputDecoration(
                    hintText: "搜索战绩",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (value) {},
                  onSubmitted: (value) {
                    controller.searchSummoner(value);
                  },
                ),
              ),
              const Spacer(),
              HorizontalButtonWidget(
                onPressed: !controller.canBack
                    ? null
                    : () {
                        controller.back();
                      },
                icon: const Icon(Icons.arrow_circle_left_outlined),
                text: "后退",
              ),
              HorizontalButtonWidget(
                onPressed: !controller.canForward
                    ? null
                    : () {
                        controller.forward();
                      },
                icon: const Icon(Icons.arrow_circle_right_outlined),
                text: "前进",
              ),
              HorizontalButtonWidget(
                onPressed: () {
                  controller.refresh();
                },
                icon: const Icon(Icons.refresh),
                text: "刷新",
              ),
            ],
          ),
        ),
        if (controller.loadingList)
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        if (!controller.loadingList)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0x33868686)),
              ),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              padding: EdgeInsets.symmetric(),
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 战绩列表
                  SizedBox(
                    width: 208,
                    child: _MatchHistoryListView(controller: controller),
                  ),
                  Container(
                    width: 1,
                    color: const Color(0x33868686),
                  ),
                  // 战绩详情
                  Expanded(
                    child: _GameDetailView(controller: controller),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _MatchHistoryListView extends StatelessWidget {
  final DeskMatchHistoryController controller;

  const _MatchHistoryListView({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.currentUserName != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              "${controller.currentUserName ?? ""}的战绩",
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: controller.matchHistoryCount,
            itemBuilder: (context, index) {
              var historyInfo = controller.currentPage?.historyInfoList![index];
              return InkWell(
                onTap: () {
                  controller.changeGameId(historyInfo?.gameId);
                },
                child: Container(
                  height: 70,
                  decoration: historyInfo?.gameId != controller.currentGameId
                      ? null
                      : BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              historyInfo?.gameResult == true
                                  ? Color(0x3302f86d)
                                  : Color(0x33f80268),
                              historyInfo?.gameResult == true
                                  ? Color(0x0002f86d)
                                  : Color(0x00f80268),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                  child: Row(children: [
                    Container(
                      width: 48,
                      height: 48,
                      margin: const EdgeInsets.all(8),
                      child: Image.asset(historyInfo?.heroIcon ?? ""),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(getGameTypeStr(historyInfo)),
                          Text("${historyInfo?.gameDate}"),
                        ],
                      ),
                    ),
                    Text(
                      historyInfo?.gameResult == true ? "胜利" : "失败",
                      style: TextStyle(
                        color: historyInfo?.gameResult == true
                            ? Colors.green
                            : Colors.red,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ]),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: controller.canToPreviousPage
                  ? () {
                      controller.toPreviousPage();
                    }
                  : null,
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Expanded(
                child: Center(
                    child: Text(controller.currentPage?.pageIndexStr ?? ""))),
            IconButton(
              onPressed: controller.canToNextPage
                  ? () {
                      controller.toNextPage();
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ],
    );
  }

  String getGameTypeStr(HistoryInfo? info) {
    if (info?.gameType == "CUSTOM_GAME") {
      return "自定义";
    }
    if (info?.gameType == "MATCHED_GAME") {
      var queueId = info?.queueId;
      switch (queueId) {
        case 420:
          return "单双排";
        case 430:
          return "匹配";
        case 440:
          return "灵活排位";
        case 890:
          return "人机模式";
        case 1700:
          return "斗魂竞技场";
      }
    }
    return "未知";
  }
}

class _GameDetailView extends StatelessWidget {
  final DeskMatchHistoryController controller;

  const _GameDetailView({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 显示2个队伍数据：我方、敌方
    if (controller.loadingDetail) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //我方数据
          if (controller.team1.isNotEmpty)
            _TeamPlayerListWidget(
              controller: controller,
              players: controller.team1,
              win: controller.winTeam == 1,
            ),
          if (controller.team2.isNotEmpty)
            _TeamPlayerListWidget(
              controller: controller,
              players: controller.team2,
              win: controller.winTeam == 2,
            ),
        ],
      ),
    );
  }
}

class _TeamPlayerListWidget extends StatelessWidget {
  final DeskMatchHistoryController controller;
  final List<Player> players;
  final bool win;

  const _TeamPlayerListWidget(
      {required this.controller, required this.players, required this.win});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            if (win) Color(0x3302f86d),
            if (win) Color(0x0002f86d),
            if (!win) Color(0x33f8024c),
            if (!win) Color(0x00f8024c),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 对局信息
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  win ? "胜方" : "败方",
                  style: TextStyle(
                    color: win ? Colors.green : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 玩家装备信息
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var player in players)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          var puuid = player.puuid;
                          controller.open(puuid, 0);
                        },
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 英雄头像
                              Container(
                                width: 32,
                                height: 32,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Image.asset(player.heroIcon ?? ""),
                              ),
                              // 玩家名称
                              Container(
                                  width: 160,
                                  child: Text("${player.userName}")),
                              const SizedBox(
                                width: 8,
                              ),
                              // 段位
                              Container(
                                  width: 60, child: Text(player.kda ?? "")),
                              const SizedBox(
                                width: 8,
                              ),
                              // 段位
                              Container(
                                  width: 80,
                                  child: Text(
                                      "${player.rankLevel1}${player.rankLevel2}")),
                              // 符文
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: player.primaryRuneIcon == null
                                    ? null
                                    : Image.network(player.primaryRuneIcon!),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: player.secondaryRuneIcon == null
                                    ? null
                                    : Image.network(player.secondaryRuneIcon!),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // 召唤师技能
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 8,
                                    height: 8,
                                    child: player.spell1Icon == null
                                        ? null
                                        : Image.network(player.spell1Icon!),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                    width: 8,
                                    height: 8,
                                    child: player.spell2Icon == null
                                        ? null
                                        : Image.network(player.spell2Icon!),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              // 6+1 装备
                              for (var value in [
                                player.item1,
                                player.item2,
                                player.item3,
                                player.item4,
                                player.item5,
                                player.item6,
                                player.item7,
                              ])
                                Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: (value == null ||
                                            value == "" ||
                                            value == "0")
                                        ? Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0x33cccccc)),
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/lol/img/item/$value.png"),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
