import 'package:flutter/material.dart';

Future<T?> showMyCustomDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Size? windowSize,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      var child = Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xff091b20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffe8be72)),
            ),
            clipBehavior: Clip.antiAlias,
            child: builder.call(context),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xff091b20),
                    borderRadius: BorderRadius.circular(80),
                    border: Border.all(color: const Color(0xffe8be72)),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Color(0xffe8be72),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      if (windowSize != null) {
        return Center(
          child: SizedBox(
            width: windowSize.width,
            height: windowSize.height,
            child: child,
          ),
        );
      }
      return Container(
        margin: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 30),
        child: child,
      );
    },
  );
}
