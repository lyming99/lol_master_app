import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lol_master_app/entities/rune/rune.dart';
import 'package:lol_master_app/services/rune/rune_service_impl.dart';
import 'package:lol_master_app/util/mvc.dart';

import '../../../widgets/tooltip.dart';

class RuneItemController extends MvcController {
  RuneConfig? runeConfig;
  bool hover = false;

  RuneItemController({
    this.runeConfig,
  });

  void onExit() {
    hover = false;
    notifyListeners();
  }

  void onHover() {
    hover = true;
    notifyListeners();
  }

  Future<void> applyToLolClient() async {
    var runeService = RuneServiceImpl();
    await runeService.applyToLolClient(runeConfig!);
  }
}

class RuneItemWidget extends MvcView<RuneItemController> {
  const RuneItemWidget({
    super.key,
    required super.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        controller.onHover();
      },
      onExit: (e) {
        controller.onExit();
      },
      cursor: MaterialStateMouseCursor.clickable,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 38, 50),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Color.fromARGB(255, 87, 71, 41), width: 2),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // 主系符文
                        Expanded(
                          child: Column(
                            children: [
                              for (var runeItem
                                  in controller.runeConfig?.primaryRunes ?? [])
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: createRuneItemTooltip(
                                    context,
                                    runeItem,
                                    Image.asset(
                                      "${runeItem.icon}",
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                        // 副系符文和属性符文
                        Expanded(
                          child: Column(
                            children: [
                              for (var runeItem
                                  in controller.runeConfig?.secondaryRunes ??
                                      [])
                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: createRuneItemTooltip(
                                    context,
                                    runeItem,
                                    Image.asset(
                                      "${runeItem.icon}",
                                      width: 32,
                                      height: 32,
                                    ),
                                  ),
                                ),
                              for (var runeItem
                                  in controller.runeConfig?.thirdRunes ?? [])
                                Container(
                                  margin: EdgeInsets.only(bottom: 4),
                                  child: createRuneItemTooltip(
                                    context,
                                    runeItem,
                                    Image.asset(
                                      "${runeItem.icon}",
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 90,
                      height: 28,
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 30, 37, 61),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Color.fromARGB(255, 232, 190, 114))),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            controller.applyToLolClient();
                          },
                          child: const Center(
                            child: Text(
                              "一键应用",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (controller.hover)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Text("${controller.runeConfig?.configName}")
        ],
      ),
    );
  }
}

Widget createRuneItemTooltip(BuildContext context, runeItem, Image image) {
  var span = TextSpan(text: runeItem.desc);
  var painter = TextPainter(text: span, textDirection: TextDirection.ltr);
  painter.layout(maxWidth: 178);
  var height = 20 + painter.height + 4;
  return CustomTooltip(
    tipWidth: 200,
    tipHeight: height,
    tipBuilder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 8, 29, 43),
          border: Border.all(
            color: Color.fromARGB(255, 144, 91, 59),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: RichText(
          text: span,
        ),
      );
    },
    child: image,
  );
}
