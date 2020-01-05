import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wechat/viewmodel/base.dart';

abstract class BaseView<T extends BaseViewModel> extends StatefulWidget {
  bool get keepAlive => false;
  List<dynamic> get viewModelParameters => null;

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
    super.initState();
    _viewModel = inject(params: widget.viewModelParameters);
    _viewModel.init();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
    _viewModel = null;
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
