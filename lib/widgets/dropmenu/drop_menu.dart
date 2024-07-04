import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';
import 'package:lol_master_app/widgets/circle_button.dart';
import 'package:lol_master_app/widgets/popup_window.dart';

class MyDropDownMenuController<T> extends MvcController {
  var listPopupTime = 0;

  var items = <T>[];

  T? selectItem;

  MyDropDownMenuController({
    required this.items,
    this.selectItem,
  });

  void updateSelectItem(int index) {
    selectItem = items[index];
    notifyListeners();
  }
}

typedef OnItemSelected = void Function(int index);

class MyDropDownMenu<T> extends MvcView<MyDropDownMenuController<T>> {
  final double width;
  final double height;
  final IndexedWidgetBuilder itemBuilder;
  final OnItemSelected? onItemSelected;

  const MyDropDownMenu({
    super.key,
    required super.controller,
    required this.itemBuilder,
    this.width = 120,
    this.height = 32,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xfff6dba6)),
      ),
      child: Builder(builder: (context) {
        return CircleButton(
          onTap: () {
            showItemPopup(context);
          },
          radius: 0,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text("${controller.selectItem??""}")),
              Icon(
                Icons.arrow_drop_down,
                size: 24,
              ),
            ],
          ),
        );
      }),
    );
  }

  void showItemPopup(BuildContext context) {
    if (controller.listPopupTime + 200 <
        DateTime.now().millisecondsSinceEpoch) {
      showCustomDropMenu(
        context: context,
        modal: false,
        width: width,
        height: max(controller.items.length * height, height),
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 2, 23, 29),
              border: Border.all(
                color: const Color(0xfff6dba6),
              ),
            ),
            child: Material(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      closePopupWindow(context);
                      controller.updateSelectItem(index);
                      onItemSelected?.call(index);
                    },
                    child: itemBuilder.call(context, index),
                  );
                },
                itemCount: controller.items.length,
              ),
            ),
          );
        },
      ).then((value) =>
          controller.listPopupTime = DateTime.now().millisecondsSinceEpoch);
    }
  }
}
