import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lol_master_app/entities/lol/game_info.dart';
import 'package:lol_master_app/services/api/lol_api.dart';
import 'package:lol_master_app/util/mvc.dart';

class DeskGameInfoController extends MvcController {
  // 当前所选择的战绩账号index
  int selectedIndex = 0;

  @override
  void onInitState(BuildContext context, MvcViewState state) {
    super.onInitState(context, state);
    LolApi.instance.addListener(onDataUpdate);
  }

  @override
  void onDidUpdateWidget(
      BuildContext context, covariant DeskGameInfoController oldController) {
    super.onDidUpdateWidget(context, oldController);
    LolApi.instance.addListener(onDataUpdate);
    oldController.removeListener(onDataUpdate);
  }

  @override
  void onDispose() {
    LolApi.instance.removeListener(onDataUpdate);
  }

  void onDataUpdate() {
    notifyListeners();
  }

  bool get hasData => myTeam.isNotEmpty;

  List<List<HistoryInfo>> get myTeam => LolApi.instance.myTeamHistoryInfo ?? [];

  List<List<HistoryInfo>> get historyList =>
      (LolApi.instance.myTeamHistoryInfo ?? []);

  List<Player> get playerList => (LolApi.instance.myTeamPlayers ?? []);

  List<String> get playerLevelList => LolApi.instance.userLevelList ?? [];

  List<HistoryInfo> get selectedHistoryList =>
      historyList.isEmpty || selectedIndex >= historyList.length
          ? []
          : historyList[selectedIndex];

  void selectPlayer(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

// mvc
class DeskGameInfoView extends MvcView<DeskGameInfoController> {
  const DeskGameInfoView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x33868686)),
      ),
      child: Row(
        children: [
          // 召唤师列表：召唤师头像+昵称
          SizedBox(
            width: 260,
            child: ListView.builder(
              itemCount: controller.playerList.length,
              itemBuilder: (context, index) {
                var player = controller.playerList[index];
                var level = controller.playerLevelList[index];
                return Container(
                  decoration: index != controller.selectedIndex
                      ? null
                      : const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              true ? Color(0x3302f86d) : Color(0x33f80268),
                              false ? Color(0x0002f86d) : Color(0x00f80268),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                  child: ListTile(
                    selected: index == controller.selectedIndex,
                    onTap: () {
                      controller.selectPlayer(index);
                    },
                    leading: Image.asset(
                      player.heroIcon ?? "",
                      width: 32,
                      height: 32,
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            (player.userName ?? ""),
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          player.rankLevel,
                          style: const TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    trailing: SizedBox(
                      width: 46,
                      child: Text(
                        level,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            width: 1,
            color: const Color(0x33868686),
          ),
          // 战绩列表: 召唤师近10局战绩
          Expanded(
            child: ListView.builder(
              itemCount: controller.selectedHistoryList.length,
              itemBuilder: (context, index) {
                var historyInfo = controller.selectedHistoryList[index];
                var player = historyInfo.currentPlayer!;
                var win = historyInfo.gameResult == true;
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        win ? Color(0x3302f86d) : Color(0x33f80268),
                        !win ? Color(0x0002f86d) : Color(0x00f80268),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // 英雄头像
                        Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.all(8),
                          child: Image.asset("${player.heroIcon}"),
                        ),
                        //
                        Text(historyInfo.getGameTypeStr()),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          win ? "胜利" : "失败",
                          style: TextStyle(
                            color: win ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(historyInfo.currentPlayer?.kda ?? ""),
                        ),
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class HistoryInfoItemView extends StatelessWidget {
  final List<HistoryInfo> historyInfoList;
  final DeskGameInfoController controller;

  const HistoryInfoItemView({
    super.key,
    required this.historyInfoList,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [],
    );
  }
}
