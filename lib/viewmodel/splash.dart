import 'dart:async';

import 'package:wechat/route.dart';
import 'package:wechat/viewmodel/base.dart';

class SplashViewModel extends BaseViewModel {
  final List<FutureOr Function()> waitFunctions;

  SplashViewModel(this.waitFunctions);

  @override
  void init() {
    super.init();
    // 确保启动页渲染出来后再执行waitFunctions
    Timer.run(() async {
      try {
        await manageFuture(Future.wait(waitFunctions.map((func) => func())));
        Router.pop();
      } on CancelException {}
    });
  }
}
