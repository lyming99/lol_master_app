import 'package:flutter/material.dart';
import 'package:lol_master_app/util/mvc.dart';

enum FilterOrderType {
  asc,
  desc,
  none;
}

class TableFilterController<T> extends MvcController {
  String? columnKey;

  //原始的items
  List<T> items = [];

  //用户选择的items
  Set<T> selectItems = {};

  //搜索显示的items
  List<T> filterItems = [];

  FilterOrderType orderType = FilterOrderType.none;

  int orderUpdateTime = 0;

  bool Function(T item, String value)? filterSearch;

  int Function(T? cellValue1, T? cellValue2)? comparator;
  bool Function(T cellValue, dynamic filterValue)? filterEquals;

  TableFilterController({
    required this.items,
    this.columnKey,
    this.filterSearch,
    this.comparator,
    this.filterEquals,
  }) : filterItems = items;

  int get itemCount => filterItems.length;

  void updateOrderType(FilterOrderType value) {
    if (orderType == value) {
      orderType = FilterOrderType.none;
    } else {
      orderType = value;
    }
    orderUpdateTime = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
  }

  void clearFilters() {
    selectItems.clear();
    orderType = FilterOrderType.none;
    notifyListeners();
  }

  void selectItem(int index) {
    var item = filterItems[index];
    if (selectItems.contains(item)) {
      selectItems.remove(item);
    } else {
      selectItems.add(item);
    }
    notifyListeners();
  }

  void selectAll() {
    if (isSelectAll()) {
      selectItems.clear();
    } else {
      selectItems.addAll(filterItems);
    }
    notifyListeners();
  }

  void searchItem(String value) {
    filterItems = items.where((element) {
      if (filterSearch != null) {
        return filterSearch?.call(element, value) == true;
      }
      return element.toString().contains(value);
    }).toList();
    notifyListeners();
  }

  T getItem(int index) {
    return filterItems[index];
  }

  bool isSelected(T item) {
    return selectItems.contains(item);
  }

  bool isSelectAll() {
    return selectItems.length == filterItems.length;
  }
}

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class TableFilterWidget<T> extends MvcView<TableFilterController<T>> {
  final ItemWidgetBuilder<T> itemBuilder;
  final String? hintText;
  final VoidCallback? onChanged;

  const TableFilterWidget({
    super.key,
    required super.controller,
    required this.itemBuilder,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xfff6dba6),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8,
                top: 8,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      controller.updateOrderType(FilterOrderType.asc);
                      onChanged?.call();
                    },
                    child: Container(
                      width: 80,
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      alignment: Alignment.center,
                      color: controller.orderType == FilterOrderType.asc
                          ? Colors.grey.withOpacity(0.1)
                          : null,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.sort,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text("升序"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      controller.updateOrderType(FilterOrderType.desc);
                      onChanged?.call();
                    },
                    child: Container(
                      width: 80,
                      height: 24,
                      color: controller.orderType == FilterOrderType.desc
                          ? Colors.grey.withOpacity(0.1)
                          : null,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.sort,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text("降序"),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      controller.clearFilters();
                      onChanged?.call();
                    },
                    child: Container(
                      width: 100,
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      alignment: Alignment.center,
                      child: const Row(
                        children: [
                          Icon(
                            Icons.playlist_remove_outlined,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text("清除筛选"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 240,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: const TextStyle(color: Colors.white),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 232, 190, 114))),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 232, 190, 114))),
                      ),
                      cursorColor: const Color.fromARGB(255, 232, 190, 114),
                      onSubmitted: (value) {},
                      onChanged: (value) {
                        controller.searchItem(value);
                      },
                      onTapOutside: (event) {},
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      onTap: () {
                        controller.selectAll();
                        onChanged?.call();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            IgnorePointer(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: Checkbox(
                                  value: controller.isSelectAll(),
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Text(
                              "全选",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  var item = controller.getItem(index - 1);
                  var isSelected = controller.isSelected(item);
                  return InkWell(
                    onTap: () {
                      controller.selectItem(index - 1);
                      onChanged?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IgnorePointer(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: Checkbox(
                                value: isSelected,
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          itemBuilder.call(
                            context,
                            controller.getItem(index - 1),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: controller.itemCount + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
