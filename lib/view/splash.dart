import 'package:flutter/cupertino.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/splash.dart';

class SplashPage extends BaseView<SplashViewModel> {
  @override
  Widget build(BuildContext context, SplashViewModel viewModel) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          child: const Text('启动屏'),
        ),
      );
}
