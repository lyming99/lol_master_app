import 'package:flutter/material.dart';
import 'package:lol_master_app/entities/account/lol_account.dart';
import 'package:lol_master_app/util/mvc.dart';

import '../../../services/api/lol_api.dart';

class LolAccountController extends MvcController {
  bool get isLogin => LolApi.instance.hasLogin();

  String get accountIcon => LolApi.instance.getAccountIcon();

  LolAccountInfo? get accountInfo => LolApi.instance.getAccountInfo();
}

class LolAccountView extends MvcView<LolAccountController> {
  const LolAccountView({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LolApi.instance.state,
      builder: (BuildContext context, value, Widget? child) {
        if (!controller.isLogin) {
          return const Text("未登录");
        }
        // div
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(60),
                      image: DecorationImage(
                        image: NetworkImage(controller.accountIcon),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.accountInfo?.gameName ?? "",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xffe8be72)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${controller.accountInfo?.summonerLevel}级",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff5ee869)),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(child: Container()),
          ],
        );
      },
    );
  }
}

class LolAccountIconController extends MvcController {
  bool get isLogin => LolApi.instance.hasLogin();

  String get accountIcon => LolApi.instance.getAccountIcon();
}

class LolAccountIconView extends MvcView<LolAccountIconController> {
  final Widget emptyIcon;

  const LolAccountIconView({
    super.key,
    required super.controller,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: LolApi.instance.state,
        builder: (BuildContext context, value, Widget? child) {
          if (!controller.isLogin) {
            return emptyIcon;
          }
          return Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.circular(60),
              image: DecorationImage(
                image: NetworkImage(controller.accountIcon),
                fit: BoxFit.cover,
              ),
            ),
          );
        });
  }
}
