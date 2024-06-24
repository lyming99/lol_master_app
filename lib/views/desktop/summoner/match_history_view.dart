import 'package:flutter/material.dart';
import 'package:lol_master_app/controllers/desktop/summoner/match_history_controller.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskMatchHistoryView extends MvcView<DeskMatchHistoryController> {
  const DeskMatchHistoryView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                width: 200,
                constraints: const BoxConstraints(maxHeight: 36),
                margin: EdgeInsets.only(left: 4),
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
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    controller.back();
                  },
                  icon: const Row(
                    children: [
                      Icon(Icons.arrow_circle_left_outlined),
                      SizedBox(
                        width: 4,
                      ),
                      Text("后退"),
                    ],
                  )),
              IconButton(
                onPressed: () {
                  //前进

                  controller.forward();
                },
                icon: Row(
                  children: [
                    const Icon(Icons.arrow_circle_right_outlined),
                    SizedBox(
                      width: 4,
                    ),
                    Text("前进"),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.refresh();
                },
                icon: Row(
                  children: [
                    const Icon(Icons.refresh),
                    SizedBox(
                      width: 4,
                    ),
                    Text("刷新"),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                Container(
                  width: 208,
                  child: _MatchHistoryListView(controller: controller),
                ),
                Container(
                  width: 1,
                  color: Color(0x33868686),
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
    return ListView.builder(
      itemCount: controller.matchHistoryCount,
      itemBuilder: (context, index) {
        var historyInfo = controller.currentPage.historyInfoList![index];
        return InkWell(
          onTap: () {
            controller.changeGameId(historyInfo.gameId);
          },
          child: Container(
            height: 70,
            decoration: historyInfo.gameId != controller.currentGameId
                ? null
                : BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        historyInfo.gameResult == true
                            ? Color(0x3302f86d)
                            : Color(0x33f80268),
                        historyInfo.gameResult == true
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
                margin: EdgeInsets.all(8),
                child: Image.asset(historyInfo.heroIcon ?? ""),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(getGameTypeStr(historyInfo)),
                    Text("${historyInfo.gameDate}"),
                  ],
                ),
              ),
              Text(
                historyInfo.gameResult == true ? "胜利" : "失败",
                style: TextStyle(
                  color: historyInfo.gameResult == true
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
          return "排位";
        case 440:
          return "灵活排位";
        case 890:
          return "人机模式";
        case 450:
          return "匹配";
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
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //我方数据
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x3302f86d),
                    Color(0x0002f86d),
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
                          "胜方",
                          style: TextStyle(
                            color: Colors.green,
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
                        children: [
                          for (var i = 0; i < 5; i++)
                            Container(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 英雄头像
                                  Container(
                                    width: 32,
                                    height: 32,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Image.asset(
                                        "assets/lol/img/champion/Aatrox.png"),
                                  ),
                                  // 玩家名称
                                  Text("果冻橙橙"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // 段位
                                  Text("10/5/9"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // 段位
                                  Text("青铜三"),
                                  // 符文
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Image.asset(
                                        "assets/lol/img/rune/7200_Domination.png"),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Image.asset(
                                        "assets/lol/img/rune/7201_Precision.png"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // 召唤师技能
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: Image.asset(
                                            "assets/lol/img/rune/7201_Precision.png"),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: Image.asset(
                                            "assets/lol/img/rune/7201_Precision.png"),
                                      ),
                                    ],
                                  ),
                                  // 6+1 装备
                                  SizedBox(
                                    width: 8,
                                  ),
                                  for (var j = 0; j < 7; j++)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      width: 24,
                                      height: 24,
                                      child: Image.asset(
                                          "assets/lol/img/item/1001.png"),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 敌方数据
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x33f8024c),
                    Color(0x00f8024c),
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
                          "败方",
                          style: TextStyle(
                            color: Colors.red,
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
                        children: [
                          for (var i = 0; i < 5; i++)
                            Container(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 英雄头像
                                  Container(
                                    width: 32,
                                    height: 32,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Image.asset(
                                        "assets/lol/img/champion/Aatrox.png"),
                                  ),
                                  // 玩家名称
                                  Text("果冻橙橙"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // 段位
                                  Text("10/5/9"),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // 段位
                                  Text("青铜三"),
                                  // 符文
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Image.asset(
                                        "assets/lol/img/rune/7200_Domination.png"),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: Image.asset(
                                        "assets/lol/img/rune/7201_Precision.png"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // 召唤师技能
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: Image.asset(
                                            "assets/lol/img/rune/7201_Precision.png"),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width: 8,
                                        height: 8,
                                        child: Image.asset(
                                            "assets/lol/img/rune/7201_Precision.png"),
                                      ),
                                    ],
                                  ),
                                  // 6+1 装备
                                  SizedBox(
                                    width: 8,
                                  ),
                                  for (var j = 0; j < 7; j++)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      width: 24,
                                      height: 24,
                                      child: Image.asset(
                                          "assets/lol/img/item/1001.png"),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
