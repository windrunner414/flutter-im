import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/route.dart';
import 'package:wechat/view/login.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/viewmodel/provider.dart';

import 'constants.dart';
import 'util/storage.dart';
import 'util/toast.dart';

/// Material和Cupertino混合，他不香吗？
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  run();
}

Future<bool> init() async {
  if (!await StorageUtil.init()) {
    return false;
  }
  initRoute();
  return true;
}

void run() async {
  if (!await init()) {
    ToastUtil.show(msg: '初始化失败');
    await Future.delayed(Duration(milliseconds: 1000));
    exit(-1);
    return;
  }

  runApp(MaterialApp(
    title: Config.AppName,
    theme: ThemeData.light().copyWith(
        primaryColor: Color(AppColors.AppBarColor),
        cardColor: Color(AppColors.AppBarColor)),
    home: ViewModelProvider(
      viewModel: LoginViewModel(),
      child: LoginPage(),
    ),
  ));
}
