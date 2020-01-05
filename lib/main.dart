import 'dart:async';
import 'dart:io' if (dart.library.html) 'dart:html';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/di.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/route.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/error_reporter.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/view/error.dart';
import 'package:wechat/view/home/home.dart';
import 'package:wechat/view/login.dart';
import 'package:wechat/view/splash.dart';

// TODO(AManWhoDoNotWantToTellHisNameAndUsingEnglishWithUpperCamelCaseAndWithoutBlankSpaceForAvoidingDartAnalysisReportWarningBecauseOfTodoStyleDoesNotMatchFlutterTodoStyle): 优化常量，fontIcon啊什么的用常量。这是一个简单&艰巨的任务，有缘人得之
void main() {
  ErrorReporterUtil.runApp(
    builder: () => BotToastInit(
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalEasyRefreshLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('zh', 'CN'),
        ],
        navigatorObservers: <NavigatorObserver>[
          BotToastNavigatorObserver(),
          RouterNavigatorObserver(),
          ErrorReportUtilNavigatorObserver(),
        ],
        onGenerateRoute: router.generator,
        initialRoute: '/',
        title: Config.AppName,
        theme: ThemeData.light().copyWith(
          primaryColor: const Color(AppColor.AppBarColor),
          cardColor: const Color(AppColor.AppBarColor),
        ),
        home: _AppInit(),
      ),
    ),
    errorBuilder: (String errorDetail) => ErrorPage(errorDetail: errorDetail),
  );
}

class _AppInit extends StatefulWidget {
  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<_AppInit> {
  final BehaviorSubject<bool> _loginStateSubject = BehaviorSubject<bool>();

  @override
  Widget build(BuildContext context) {
    _initOnEveryBuild();
    return WillPopScope(
      onWillPop: () async {
        if (!kIsWeb && Platform.isAndroid) {
          const MethodChannel('android.move_task_to_back')
              .invokeMethod('moveTaskToBack');
          return false;
        }
        return true;
      },
      child: StreamBuilder<bool>(
        stream: _loginStateSubject,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return snapshot.data ? HomePage() : LoginPage();
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer.run(_initOnAppStartup);
  }

  void _initOnEveryBuild() {
    initScreenUtil(
        width: 414, height: 736, allowFontScaling: true, context: context);
  }

  Future<void> _initOnAppStartup() async {
    startDartIn(modules);

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    final NavigatorState navigator = Navigator.of(context);
    navigator.push(PageRouteBuilder<dynamic>(
      pageBuilder: (_, __, ___) => SplashPage(),
      transitionDuration: Duration.zero,
    ));

    await Future.wait(<Future<void>>[
      // delay一下，先让启动屏显示出来
      Future<void>.delayed(Duration.zero, () async {
        initRoute();
        await Future.wait(<Future<void>>[
          StorageUtil.init(),
          initWorker(),
        ]);
        await Future.wait(<Future<void>>[
          initService(),
          initAppState(),
        ]);

        ownUserInfo
            .distinct((User prev, User next) =>
                prev?.userSession == next?.userSession)
            .listen((User user) {
          if ((user?.userSession ?? '').isNotEmpty) {
            _loginStateSubject.add(true);
          } else {
            _loginStateSubject.add(false);
          }
        });
      }),
      // 多给点时间让页面加载好
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);

    _loginStateSubject.listen((_) {
      navigator.popUntil((Route<dynamic> route) => route.isFirst);
    });
  }
}
