import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RuneClip {
  double left = 0;
  double top = 0;
  double right = 1;
  double bottom = 1;

  RuneClip({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  double get width => right - left;

  double get height => bottom - top;
}

class RuneBackgroundWidget extends StatelessWidget {
  final String? name;
  final RuneClip? runeClip;
  final bool showRune;

  const RuneBackgroundWidget({
    super.key,
    this.name,
    this.runeClip,
    this.showRune = true,
  });

  @override
  Widget build(BuildContext context) {
    var realWidth = 1162.0;
    var realHeight = 720.0;
    var offsetLeft = 0.0;
    var offsetTop = 0.0;
    var runeClip = this.runeClip;
    if (runeClip != null) {
      realWidth = runeClip.width * 1162;
      realHeight = runeClip.height * 720;
      offsetLeft = -runeClip.left * 1162;
      offsetTop = -runeClip.top * 720;
    }
    return FittedBox(
      child: SizedBox(
        width: realWidth,
        height: realHeight,
        child: Stack(
          children: [
            Positioned(
              left: offsetLeft,
              top: offsetTop,
              child: SizedBox(
                width: 1162,
                height: 720,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 1162,
                      height: 720,
                      child: Image.asset(
                        "assets/lol/img/rune/bg_$name.png",
                      ),
                    ),
                    if (showRune)
                      Positioned(
                        top: 0,
                        left: 460,
                        child: SizedBox(
                          width: 700,
                          height: 720,
                          child: Image.asset(
                            "assets/lol/img/rune/item_$name.png",
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
