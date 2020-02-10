import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartin/dartin.dart';
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
    builder: () {
      router.addRoutes(appRoutes);
      return BotToastInit(
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
          builder: (BuildContext context, Widget widget) =>
              ScreenUtilInitializer(
            designWidth: 414,
            designHeight: 736,
            allowFontScaling: true,
            child: widget,
          ),
          home: _AppInitializer(),
        ),
      );
    },
    errorBuilder: (String errorDetail) => ErrorPage(errorDetail: errorDetail),
  );
}

class _AppInitializer extends StatefulWidget {
  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<_AppInitializer> {
  @override
  Widget build(BuildContext context) => Container();

  @override
  void initState() {
    super.initState();
    Timer.run(_initOnAppStartup);
  }

  Future<void> _initOnAppStartup() async {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    }

    final CloseLayerFunc closeSplashPage =
        showWidget(builder: (_) => SplashPage(), backgroundColor: Colors.white);

    await Future.wait(<Future<void>>[
      // delay一下，先让启动屏显示出来
      Future<void>.delayed(Duration.zero, () async {
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
            .listen((User user) {
          closeAllLayer();
          if ((user?.userSession ?? '').isNotEmpty) {
            // TODO(windrunner414): https://github.com/flutter/flutter/issues/49851
            router.pushAndRemoveUntil('/home', (_) => false);
          } else {
            router.pushAndRemoveUntil('/login', (_) => false);
          }
        });

        appInitialized.value = true;
      }),
      // 多给点时间让页面加载好
      Future<void>.delayed(const Duration(milliseconds: 500)),
    ]);

    closeSplashPage();
  }
}
