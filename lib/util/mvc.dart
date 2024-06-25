import 'package:flutter/material.dart';

typedef MvcBuilder<T> = Widget Function(T controller);

// 也可以封装mvvm，mvp，看看相关文章
class MvcView<T extends MvcController> extends StatefulWidget {
  final T controller;
  final MvcBuilder<T>? builder;

  const MvcView({
    super.key,
    required this.controller,
    this.builder,
  });

  Widget build(BuildContext context) {
    return builder?.call(controller) ?? Container();
  }

  @override
  State<MvcView> createState() => MvcViewState();
}

class MvcViewState extends State<MvcView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.onInitState(context, this);
    widget.controller.addListener(onChanged);
  }

  void onChanged() {
    if (context.mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(onChanged);
    widget.controller.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.build(context);
  }

  @override
  void didUpdateWidget(covariant MvcView<MvcController> oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(onChanged);
    widget.controller.addListener(onChanged);
    widget.controller.onDidUpdateWidget(context, oldWidget.controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => widget.controller.wantKeepAlive;
}

class MvcController with ChangeNotifier {
  bool get wantKeepAlive => false;

  /// 组件初始化时会触发此方法
  void onInitState(BuildContext context, MvcViewState state) {}

  /// 父节点setState时会触发此方法
  void onDidUpdateWidget(
      BuildContext context, covariant MvcController oldController) {}

  /// widget树中，若节点的父级结构中的层级 或 父级结构中的任一节点的widget类型有变化，节点会调用didChangeDependencies；
  /// 若仅仅是父级结构某一节点的widget的某些属性值变化，节点不会调用didChangeDependencies
  void didChangeDependencies() {}

  /// 组件关闭时会触发此方法
  void onDispose() {}

  static T of<T extends MvcController>(BuildContext context) {
    return context.findAncestorStateOfType<MvcViewState>()!.widget.controller
        as T;
  }
}
