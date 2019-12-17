import 'package:flutter/material.dart';
import 'base.dart';

class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  final T viewModel;
  final Widget child;

  ViewModelProvider({
    @required this.viewModel,
    @required this.child,
  });

  static T of<T extends BaseViewModel>(BuildContext context) {
    ViewModelProvider<T> provider = context.findAncestorWidgetOfExactType<ViewModelProvider<T>>();
    return provider.viewModel;
  }

  @override
  _ViewModelProviderState createState() => _ViewModelProviderState();
}

class _ViewModelProviderState extends State<ViewModelProvider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }
}
