import 'dart:ui';

import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'di.dart';
import 'route.dart';
import 'util/storage.dart';
import 'view/login.dart';
import 'viewmodel/login.dart';
import 'viewmodel/provider.dart';

/// Material和Cupertino混合，他不香吗
void main() {
  runApp(FutureBuilder<bool>(
      future: init(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return (!snapshot.hasError && snapshot.data)
              ? MaterialApp(
                  title: Config.AppName,
                  theme: ThemeData.light().copyWith(
                      primaryColor: Color(AppColors.AppBarColor),
                      cardColor: Color(AppColors.AppBarColor)),
                  home: ViewModelProvider(
                    viewModel: inject<LoginViewModel>(),
                    child: LoginPage(),
                  ),
                )
              : MaterialApp(
                  home: Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: Text(
                        "啊哦，初始化失败了",
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.black87,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                );
        } else {
          return Container();
        }
      }));
}

Future<bool> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (!await StorageUtil.init()) {
    return false;
  }
  initRoute();
  startDartIn(appModule);
  return true;
}
