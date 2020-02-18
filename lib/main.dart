import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/di.dart';
import 'package:wechat/common/route.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/error_reporter.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/view/error.dart';
import 'package:wechat/view/splash.dart';

// TODO(AManWhoDoNotWantToTellHisNameAndUsingEnglishWithUpperCamelCaseAndWithoutBlankSpaceForAvoidingDartAnalysisReportWarningBecauseOfTodoStyleDoesNotMatchFlutterTodoStyle): 优化常量，fontIcon啊什么的用常量。这是一个简单&艰巨的任务，有缘人得之
void main() {
  ErrorReporter.runApp(
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
        title: Config.AppName,
        navigatorObservers: <NavigatorObserver>[
          BotToastNavigatorObserver(),
          ErrorReporterNavigatorObserver(),
          RouterNavigatorObserver(),
        ],
        onGenerateRoute: router.generator,
        onGenerateInitialRoutes: _AppInitializer.initialRoutesGenerator,
        onUnknownRoute: (RouteSettings settings) => CupertinoPageRoute<dynamic>(
          builder: (BuildContext context) =>
              const ErrorPage(errorDetail: '页面走丢啦~'),
          settings: settings,
        ),
        builder: (BuildContext context, Widget widget) => ScreenUtilInitializer(
          designWidth: 414,
          designHeight: 736,
          allowFontScaling: true,
          child: widget,
        ),
      ),
    ),
    errorBuilder: (String errorDetail) => ErrorPage(errorDetail: errorDetail),
  );
}

class _AppInitializer extends StatefulWidget {
  static final Set<String> initialRoutes = <String>{'/'};

  static List<Route<dynamic>> initialRoutesGenerator(String initialRoute) {
    assert(initialRoute.startsWith('/')); // 默认路由必须是/

    initialRoute = initialRoute.substring(1);
    final List<String> routeParts = initialRoute.split('/');
    String route = '';
    for (String part in routeParts) {
      route += '/' + part;
      initialRoutes.add(route);
    }

    return <Route<dynamic>>[
      PageRouteBuilder<dynamic>(
        settings: const RouteSettings(name: '', isInitialRoute: true),
        pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) =>
            _AppInitializer(),
        transitionDuration: Duration.zero,
      )
    ];
  }

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  @override
  Widget build(BuildContext context) => Container();

  @override
  void initState() {
    super.initState();
    Timer.run(_init);
  }

  Future<void> _init() async {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    }

    final CloseLayerFunc closeSplashPage =
        showWidget(builder: (_) => SplashPage(), backgroundColor: Colors.white);

    await Future.wait(<Future<void>>[
      // delay一下，先让启动屏显示出来
      Future<void>.delayed(Duration.zero, () async {
        router.addRoutes(appRoutes);
        startDartIn(appModules);
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
            .skip(1)
            .listen((User user) {
          closeAllLayer();
          router.pushAndRemoveUntil(
              _AppInitializer.initialRoutes.first, (_) => false);
        });

        router.pushReplacement(_AppInitializer.initialRoutes.first);
        // TODO(windrunner414): 路由处理明显有问题，不应该这样判断，还有就是/xxx/yyy会push俩页面但是xxx的传参可能没了就挂了，然后允许push应该弄个白名单，不要所有页面都可以这样push，不知道有没有办法判断所有外部的push，看看android的外部启动intent会怎么影响路由
        _AppInitializer.initialRoutes.skip(1).forEach(router.push);
      }),
      // 多给点时间让页面加载好
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);

    closeSplashPage();
  }
}
