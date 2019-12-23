import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/viewmodel/base.dart';

class ViewModelProvider<T extends BaseViewModel> extends StatefulWidget {
  final Widget child;

  ViewModelProvider({
    Key key,
    @required this.child,
  })  : assert(child != null),
        assert(T != BaseViewModel),
        super(key: key);

  static T of<T extends BaseViewModel>(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_ViewModelProviderInherited<T>>()
      .viewModel;

  @override
  _ViewModelProviderState<T> createState() => _ViewModelProviderState<T>();
}

class _ViewModelProviderState<T extends BaseViewModel>
    extends State<ViewModelProvider<T>> {
  final T viewModel = inject();

  @override
  Widget build(BuildContext context) =>
      _ViewModelProviderInherited<T>(viewModel: viewModel, child: widget.child);

  @override
  void initState() {
    viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}

class _ViewModelProviderInherited<T extends BaseViewModel>
    extends InheritedWidget {
  final T viewModel;

  _ViewModelProviderInherited(
      {Key key, @required this.viewModel, @required Widget child})
      : assert(T != BaseViewModel),
        assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
