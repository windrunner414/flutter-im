import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/viewmodel/base.dart';

class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  final Widget child;
  final T viewModel;

  ViewModelProvider({
    @required this.child,
  })  : assert(child != null),
        assert(T != BaseViewModel),
        viewModel = inject();

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
