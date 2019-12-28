import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/splash.dart';

typedef _WaitFunction = FutureOr Function();

class SplashPage extends BaseView<SplashViewModel> {
  @override
  final List<_WaitFunction> viewModelParameters;

  SplashPage(List<_WaitFunction> waitFunctions)
      : viewModelParameters = Set<_WaitFunction>.from(waitFunctions).toList()
          ..add(() => Future.delayed(Duration(milliseconds: 500)));

  @override
  Widget build(BuildContext context, SplashViewModel viewModel) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          child: Text("启动屏"),
        ),
      );
}
