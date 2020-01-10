import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/viewmodel/base.dart';

/// 如果T不是BaseViewModel就会创建一个viewModel绑定上去，否则build的viewModel永远为null
/// 若需要共享viewModel，需要额外提供一个ViewModelProvider
abstract class BaseView<T extends BaseViewModel> extends StatefulWidget {
  Widget build(BuildContext context, T viewModel);

  @override
  BaseViewState<T, BaseView<T>> createState() =>
      BaseViewState<T, BaseView<T>>();
}

class BaseViewState<T extends BaseViewModel, E extends BaseView<T>>
    extends State<E> {
  T viewModel;

  @override
  Widget build(BuildContext context) => widget.build(context, viewModel);

  @override
  void initState() {
    super.initState();
    _initViewModel();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeViewModel();
  }

  T createViewModel() => inject();

  void _initViewModel() {
    viewModel = createViewModel();
    viewModel?.init();
  }

  void _disposeViewModel() {
    viewModel?.dispose();
    viewModel = null;
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
