import 'package:flutter/material.dart';

enum TooltipDirection {
  top,
  bottom,
  left,
  right,
}

class CustomTooltip extends StatefulWidget {
  final Widget child;
  final WidgetBuilder tipBuilder;
  final double tipWidth;
  final double tipHeight;
  final TooltipDirection defaultDirection;

  const CustomTooltip({
    super.key,
    required this.child,
    required this.tipBuilder,
    required this.tipWidth,
    required this.tipHeight,
    this.defaultDirection = TooltipDirection.top,
  });

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState extends State<CustomTooltip> {
  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          onEnter(context);
        },
        onExit: (event) {
          onExit(context);
        },
        child: widget.child,
      );
    });
  }

  void onEnter(BuildContext context) {
    if (overlayEntry != null) {
      return;
    }
    var box = context.findRenderObject();
    if (box is! RenderBox) {
      return;
    }

    overlayEntry = OverlayEntry(builder: (context) {
      return buildTipContent(context, box);
    });
    Overlay.of(context, rootOverlay: true).insert(overlayEntry!);
  }

  void onExit(BuildContext context) {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  Widget buildTipContent(BuildContext context, RenderBox renderBox) {
    if (!renderBox.attached) {
      return Container();
    }
    var boxGlobalOffset = renderBox.localToGlobal(Offset.zero);
    var boxSize = renderBox.size;
    // 计算要显示的位置
    var viewSize = MediaQuery.of(context).size;
    Offset offset = getOffset(boxGlobalOffset, boxSize);
    if (offset.dx + widget.tipWidth + 10 > viewSize.width) {
      offset = Offset(viewSize.width - widget.tipWidth - 10, offset.dy);
    }
    if (offset.dx < 10) {
      offset = Offset(10, offset.dy);
    }
    return IgnorePointer(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              top: offset.dy,
              left: offset.dx,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.tipWidth,
                height: widget.tipHeight,
                child: widget.tipBuilder(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Offset getOffset(Offset boxGlobalOffset, Size boxSize) {
    Offset offset;
    if (boxGlobalOffset.dy - widget.tipHeight - 10 > 0) {
      // 上
      offset = Offset(
        boxGlobalOffset.dx + boxSize.width / 2 - widget.tipWidth / 2,
        boxGlobalOffset.dy - widget.tipHeight - 10,
      );
    } else {
      // 下
      offset = Offset(
        boxGlobalOffset.dx + boxSize.width / 2 - widget.tipWidth / 2,
        boxGlobalOffset.dy + boxSize.height + 10,
      );
    }
    return offset;
  }
}
