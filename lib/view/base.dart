import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/viewmodel/base.dart';

/// 如果T不是BaseViewModel就会创建一个viewModel绑定上去，否则build的viewModel永远为null
/// 若需要共享viewModel，需要额外提供一个ViewModelProvider
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
    if (T != BaseViewModel) {
      _viewModel = inject(params: widget.viewModelParameters);
      _viewModel.init();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel?.dispose();
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

bool exceptCancelException(Object error) => error is! CancelException;

extension ViewFutureExtension<T> on Future<T> {
  /// 捕获所有错误，但只处理test为true的
  Future<T> catchAll(Function onError,
          {bool test(Object error), Function onOtherError}) =>
      catchError((Object error, StackTrace stackTrace) {
        if (test == null || test(error)) {
          if (onError is Function(dynamic, StackTrace)) {
            return onError(error, stackTrace);
          } else {
            return onError(error);
          }
        } else {
          if (onOtherError == null) {
            return null;
          }
          if (onOtherError is Function(dynamic, StackTrace)) {
            return onOtherError(error, stackTrace);
          } else {
            return onOtherError(error);
          }
        }
      });

  /// 显示loading并在future结束时关闭
  Future<T> showLoadingUntilComplete() {
    final UniqueKey loadingKey = showLoading();
    whenComplete(() => closeLoading(loadingKey));
    return this;
  }
}
