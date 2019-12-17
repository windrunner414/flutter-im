import 'package:flutter/widgets.dart';

abstract class BaseViewModel {
  bool _isFirstInit = true;

  @mustCallSuper
  void init() {
    if (_isFirstInit) {
      _isFirstInit = false;
      doInit();
    }
  }

  @protected
  void doInit();

  void dispose();
}
