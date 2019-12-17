import 'package:flutter/widgets.dart';

abstract class BaseViewModel {
  bool _isFirstInit = true;

  @mustCallSuper
  void init(BuildContext context) {
    if (_isFirstInit) {
      _isFirstInit = false;
      doInit(context);
    }
  }

  @protected
  void doInit(BuildContext context);

  void dispose();
}
