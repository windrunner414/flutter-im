import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/di.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/route.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/error_reporter.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';
import 'package:wechat/view/error.dart';
import 'package:wechat/view/home.dart';
import 'package:wechat/view/login.dart';
import 'package:wechat/view/splash.dart';

void main() {
  ErrorReporterUtil.runApp(
    builder: () => BotToastInit(
      child: MaterialApp(
        navigatorObservers: [
          BotToastNavigatorObserver(),
          RouterNavigatorObserver(),
          ErrorReportUtilNavigatorObserver(),
        ],
        onGenerateRoute: Router.generator,
        title: Config.AppName,
        theme: ThemeData.light().copyWith(
          primaryColor: Color(AppColor.AppBarColor),
          cardColor: Color(AppColor.AppBarColor),
        ),
        home: _AppInit(
          child: StreamBuilder(
            stream: AppState.ownUserInfo.distinct((User prev, User next) =>
                prev?.userSession == next?.userSession),
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) =>
                snapshot.connectionState != ConnectionState.active
                    ? Container()
                    : ((snapshot.data?.userSession ?? "").isNotEmpty
                        ? HomePage()
                        : LoginPage()),
          ),
        ),
      ),
    ),
    errorBuilder: (String errorDetail) => ErrorPage(errorDetail: errorDetail),
  );
}

class _AppInit extends StatefulWidget {
  final Widget child;

  _AppInit({this.child});

  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<_AppInit> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        width: 414, height: 736, allowFontScaling: true, context: context);
    return widget.child;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _initBeforeShowSplash();
    List<FutureOr Function()> waitFunctions = [_initApp];
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => SplashPage(waitFunctions),
      transitionDuration: Duration.zero,
    ));
  }

  Future<void> _initBeforeShowSplash() async {
    startDartIn(appModule);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  Future<void> _initApp() async {
    Router.init();
    await Future.wait([
      StorageUtil.init(),
      WorkerUtil.init(),
    ]);
    await Future.wait([
      AppState.init(),
      Service.init(),
    ]);
  }
}
