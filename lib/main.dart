import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/di.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/route.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/error_reporter.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/view/error.dart';
import 'package:wechat/view/home/home.dart';
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
        home: _AppInit(),
      ),
    ),
    errorBuilder: (String errorDetail) => ErrorPage(errorDetail: errorDetail),
  );
}

class _AppInit extends StatefulWidget {
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<_AppInit> {
  final BehaviorSubject<bool> _loginStateSubject = BehaviorSubject();

  @override
  Widget build(BuildContext context) {
    _initOnEveryBuild();
    return StreamBuilder(
      stream: _loginStateSubject,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return snapshot.data ? HomePage() : LoginPage();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initOnAppStartup();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initOnEveryBuild() {
    ScreenUtil.init(
        width: 414, height: 736, allowFontScaling: true, context: context);
  }

  Future<void> _initOnAppStartup() async {
    startDartIn(appModule);

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }

    NavigatorState navigator = Navigator.of(context);
    navigator.push(PageRouteBuilder(
      pageBuilder: (_, __, ___) => SplashPage(),
      transitionDuration: Duration.zero,
    ));

    await Future.wait([
      // delay一下，先让启动屏显示出来
      Future.delayed(Duration.zero, () async {
        Router.init();
        await Future.wait([
          StorageUtil.init(),
          WorkerUtil.init(),
        ]);
        await Future.wait([
          Service.init(),
          AppState.init(),
        ]);

        AppState.ownUserInfo
            .distinct((User prev, User next) =>
                prev?.userSession == next?.userSession)
            .listen((User user) {
          _loginStateSubject
              .add((user?.userSession ?? "").isEmpty ? false : true);
        });
      }),
      // 多给点时间让页面加载好
      Future.delayed(Duration(milliseconds: 500)),
    ]);

    _loginStateSubject.listen((_) {
      navigator.popUntil((route) => route.isFirst);
    });
  }
}
