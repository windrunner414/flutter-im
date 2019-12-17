import 'package:flutter/material.dart';

import 'base.dart';

class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget child;

  // 设置一个UniqueKey，每次重建的时候state也会重新创建，而不是保留以前的
  ViewModelProvider({
    @required this.viewModel,
    @required this.child,
  })  : assert(viewModel != null),
        assert(child != null),
        super(key: UniqueKey());

  static T of<T extends BaseViewModel>(BuildContext context) =>
      context.findAncestorWidgetOfExactType<ViewModelProvider<T>>().viewModel;

  @override
  _ViewModelProviderState createState() => _ViewModelProviderState();
}

class _ViewModelProviderState extends State<ViewModelProvider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    widget.viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }
}
