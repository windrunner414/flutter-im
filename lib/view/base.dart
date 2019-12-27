import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wechat/viewmodel/base.dart';

abstract class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final bool keepAlive = false;
  final List viewModelParameters = null;

  Widget build(BuildContext context, T viewModel);

  @override
  @nonVirtual
  _BaseViewState<T> createState() =>
      keepAlive ? _BaseViewStateWithKeepAlive<T>() : _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  T _viewModel;

  @override
  Widget build(BuildContext context) => widget.build(context, _viewModel);

  @override
  void initState() {
    _viewModel = inject(params: widget.viewModelParameters);
    _viewModel.init();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _viewModel = null;
    super.dispose();
  }
}

class _BaseViewStateWithKeepAlive<T extends BaseViewModel>
    extends _BaseViewState<T> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.build(context, _viewModel);
  }
}
