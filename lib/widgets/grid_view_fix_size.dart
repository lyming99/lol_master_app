import 'dart:math';

import 'package:flutter/rendering.dart';

class SliverGridDelegateWithFixedSize extends SliverGridDelegate {
  const SliverGridDelegateWithFixedSize({
    required this.itemWidth,
    required this.itemHeight,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.fixOneItem = false,
  })  : assert(itemWidth > 0),
        assert(mainAxisSpacing >= 0),
        assert(crossAxisSpacing >= 0);

  final double itemWidth;

  final double itemHeight;

  final double mainAxisSpacing;

  final double crossAxisSpacing;
  final bool fixOneItem;

  bool _debugAssertIsValid() {
    assert(itemWidth > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    int crossAxiCount = 1;
    for (var i = 1;; i++) {
      if (itemWidth * i + (crossAxisSpacing * (i + 1)) >
          constraints.crossAxisExtent) {
        break;
      }
      crossAxiCount = i;
    }
    // 平均分配
    var itemRealWidth = itemWidth;
    if (crossAxiCount == 1 && fixOneItem) {
      itemRealWidth = constraints.crossAxisExtent;
    }
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxiCount,
      mainAxisStride: itemHeight + mainAxisSpacing,
      crossAxisStride: itemRealWidth + crossAxisSpacing,
      childMainAxisExtent: itemHeight,
      childCrossAxisExtent: itemRealWidth,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithFixedSize oldDelegate) {
    return oldDelegate.itemWidth != itemWidth ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing;
  }
}
