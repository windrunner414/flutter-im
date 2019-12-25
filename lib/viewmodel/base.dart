import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class CancelException implements Exception {
  String toString() => "CancelException";
}

abstract class BaseViewModel {
  @nonVirtual
  bool _active = true;
  @nonVirtual
  bool get active => _active;
  @nonVirtual
  final Set<Completer> _managedCompleter = Set();
  @nonVirtual
  final Map<Symbol, Completer> _managedNamedCompleter = {};

  @mustCallSuper
  void init() {}

  @mustCallSuper
  void dispose() {
    _active = false;
    _managedCompleter.removeWhere((Completer completer) {
      completer.completeError(CancelException());
      return true;
    });
    _managedNamedCompleter.removeWhere((Symbol symbol, Completer completer) {
      completer.completeError(CancelException());
      return true;
    });
  }

  /// 在dispose的时候取消掉，如果存在name一样且未完成的任务，取消之前的
  @protected
  @nonVirtual
  Future manageFuture(Future future, [Symbol name]) {
    Completer completer = Completer();
    if (!active) {
      completer.completeError(CancelException());
      return completer.future;
    }

    future.then((value) {
      if (!completer.isCompleted) {
        completer.complete(value);
        name == null
            ? _managedCompleter.remove(completer)
            : _managedNamedCompleter.remove(name);
      }
    }, onError: (error) {
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
      Completer last = _managedNamedCompleter[name];
      if (last != null) {
        last.completeError(CancelException());
      }
      _managedNamedCompleter[name] = completer;
    }

    return completer.future;
  }
}
