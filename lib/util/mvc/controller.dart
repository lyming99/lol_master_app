import 'package:flutter/material.dart';

class MvcController with ChangeNotifier {
  /// 是否需要在PageView中保持状态
  bool get wantKeepAlive => false;

  /// 组件初始化时会触发此方法
  void onInitState(BuildContext context) {}

  /// 父节点setState时会触发此方法
  void onDidUpdateWidget(BuildContext context, MvcController oldController) {}

  /// widget树中，若节点的父级结构中的层级 或 父级结构中的任一节点的widget类型有变化，节点会调用didChangeDependencies；
  /// 若仅仅是父级结构某一节点的widget的某些属性值变化，节点不会调用didChangeDependencies
  void didChangeDependencies() {}

  /// 组件关闭时会触发此方法
  void onDispose() {}
}
