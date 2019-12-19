import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';

import 'base.dart';

class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  final Widget child;

  ViewModelProvider({
    @required this.child,
  })  : assert(child != null),
        assert(T != BaseViewModel),
        super(key: GlobalKey());

  static T of<T extends BaseViewModel>(BuildContext context) =>
      ((context.findAncestorWidgetOfExactType<ViewModelProvider<T>>().key
                  as GlobalKey)
              .currentState as _ViewModelProviderState<T>)
          .viewModel;

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();
}

class _ViewModelProviderState<T extends BaseViewModel>
    extends State<ViewModelProvider<T>> {
  T _viewModel;
  T get viewModel => _viewModel;

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    _viewModel = inject();
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}
