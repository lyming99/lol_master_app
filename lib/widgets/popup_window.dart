import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'popup_stack.dart';


Future<void> showPopupWindow(BuildContext context, Widget widget) async {
  var comp = Completer();
  OverlayEntry? entry;
  entry = OverlayEntry(builder: (context) {
    return PopupWindowWidget(
      entry: entry!,
      child: widget,
    );
  });
  Overlay.of(context, rootOverlay: true).insert(entry);
  entry.addListener(() {
    if (!entry!.mounted) {
      comp.complete();
    }
  });
  await comp.future;
}

void closePopupWindow(BuildContext context) {
  var widget = context.findAncestorWidgetOfExactType<PopupWindowWidget>();
  if (widget == null) {
    return;
  }
  widget.entry?.remove();
  if (widget.modal) {
    Navigator.of(context).pop();
  }
}

Future<void> showCustomDropMenu({
  required BuildContext context,
  required WidgetBuilder builder,
  Rect? anchor,
  Alignment alignment = Alignment.bottomLeft,
  Alignment overflowAlignment = Alignment.bottomRight,
  Offset offset = Offset.zero,
  double width = 200,
  double height = 200,
  double margin = 0,
  bool modal = false,
}) async {
  if (anchor == null) {
    var box = context.findRenderObject() as RenderBox;
    anchor = box.localToGlobal(offset) & box.size;
  }
  var popupWidget = PopupStack(
    children: [
      PopupPositionWidget(
        anchorRect: anchor,
        keepVision: true,
        width: width,
        height: height,
        popupAlignment: alignment,
        overflowAlignment: overflowAlignment,
        verticalAlignment: VerticalAlignment.top,
        child: Builder(
          builder: builder,
        ),
      )
    ],
  );
  if (modal) {
    await showDialog(
        barrierColor: Colors.transparent,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return PopupWindowWidget(
            entry: null,
            modal: true,
            child: popupWidget,
          );
        });
    return;
  }
  await showPopupWindow(context, popupWidget);
}

class PopupWindowWidget extends StatefulWidget {
  final OverlayEntry? entry;
  final Widget child;
  final bool modal;
  final bool focus;

  const PopupWindowWidget({
    super.key,
    this.focus = true,
    this.modal = false,
    required this.entry,
    required this.child,
  });

  @override
  State<PopupWindowWidget> createState() => _PopupWindowWidgetState();
}

class _PopupWindowWidgetState extends State<PopupWindowWidget> {
  @override
  void initState() {
    super.initState();
    GestureBinding.instance.pointerRouter.addGlobalRoute(onEvent);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(onEvent);
    super.dispose();
  }

  void onEvent(PointerEvent event) {
    if (mounted && event is PointerDownEvent) {
      var box = context.findRenderObject();
      if (box is RenderBox) {
        if (!box.hitTest(BoxHitTestResult(), position: event.position)) {
          widget.entry?.remove();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        autofocus: widget.focus,
        child: widget.child,
      ),
    );
  }
}
