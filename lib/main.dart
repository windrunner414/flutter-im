import 'package:bot_toast/bot_toast.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/di.dart';
import 'package:wechat/repository/remote/api.dart';
import 'package:wechat/route.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';
import 'package:wechat/view/home/home.dart';
import 'package:wechat/view/login.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/widget/viewmodel_provider.dart';

/// Material和Cupertino混合，他不香吗
void main() {
  runApp(BotToastInit(
    child: MaterialApp(
      navigatorObservers: [
        BotToastNavigatorObserver(),
        Router.navigatorObserver,
      ],
      onGenerateRoute: Router.generator,
      title: Config.AppName,
      theme: ThemeData.light().copyWith(
          primaryColor: Color(AppColors.AppBarColor),
          cardColor: Color(AppColors.AppBarColor)),
      home: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? (snapshot.hasError ? errorPage() : rootPage())
                : Container(),
      ),
    ),
  ));
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await StorageUtil.init();
  await WorkerUtil.init();
  Router.init();
  startDartIn(appModule);
  ApiServer.init(); // 必须在storage初始化后调用
}

/// 这里只有初始化失败才会显示，后续可以改成全局处理未捕获的异常
Widget errorPage() => Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      color: Colors.white,
      child: Center(
        child: Text(
          "啊哦，崩溃了",
          style: TextStyle(
            fontSize: 24,
            decoration: TextDecoration.none,
            color: Colors.black87,
          ),
        ),
      ),
    );

Widget rootPage() => false
    ? HomePage()
    : ViewModelProvider<LoginViewModel>(
        child: LoginPage(),
      );
