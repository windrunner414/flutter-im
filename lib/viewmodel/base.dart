import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:wechat/common/exception.dart';

abstract class BaseViewModel {
  @nonVirtual
  bool _active = true;
  @nonVirtual
  bool get active => _active;
  @nonVirtual
  final Set<Completer<dynamic>> _managedCompleter = <Completer<dynamic>>{};
  @nonVirtual
  final Map<Symbol, Completer<dynamic>> _managedNamedCompleter =
      <Symbol, Completer<dynamic>>{};

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    _active = false;
    _managedCompleter.removeWhere((Completer<dynamic> completer) {
      completer.completeError(const CancelException());
      return true;
    });
    _managedNamedCompleter
        .removeWhere((Symbol symbol, Completer<dynamic> completer) {
      completer.completeError(const CancelException());
      return true;
    });
  }

  /// 在dispose的时候取消掉，如果存在name一样且未完成的任务，取消之前的
  @nonVirtual
  Future<T> bindFuture<T>(Future<T> future, [Symbol name]) {
    final Completer<T> completer = Completer<T>();
    if (!active) {
      completer.completeError(const CancelException());
      return completer.future;
    }

    future.then((T value) {
      if (!completer.isCompleted) {
        completer.complete(value);
        name == null
            ? _managedCompleter.remove(completer)
            : _managedNamedCompleter.remove(name);
      }
    }, onError: (Object error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
        name == null
            ? _managedCompleter.remove(completer)
            : _managedNamedCompleter.remove(name);
      }
    });

    if (name == null) {
      _managedCompleter.add(completer);
    } else {
      final Completer<dynamic> last = _managedNamedCompleter[name];
      if (last != null) {
        last.completeError(const CancelException());
      }
      _managedNamedCompleter[name] = completer;
    }

    return completer.future;
  }
}

extension ViewModelFutureExtension<T> on Future<T> {
  /// 绑定到一个viewModel上，若viewModel dispose了则抛出CancelException
  Future<T> bindTo(BaseViewModel viewModel, [Symbol name]) =>
      viewModel.bindFuture(this, name);

  /// 将抛出的错误（除了CancelException）用ViewModelException包裹
  Future<T> wrapError<E extends Object>() => catchError(
      (E error, StackTrace stackTrace) =>
          throw ViewModelException<E>(error, originalStackTrace: stackTrace),
      test: (Object error) => error is! CancelException && error is E);
}
