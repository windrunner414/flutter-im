import 'dart:async';

import 'package:wechat/route.dart';
import 'package:wechat/viewmodel/base.dart';

class SplashViewModel extends BaseViewModel {
  final List<FutureOr Function()> waitFunctions;

  SplashViewModel(this.waitFunctions);

  @override
  void init() async {
    super.init();
    try {
      await manageFuture(Future.wait(
          waitFunctions.map((func) => Future.delayed(Duration.zero, func))));
      Router.pop();
    } on CancelException {}
  }
}
