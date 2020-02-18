import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/view/add_friend.dart';
import 'package:wechat/view/business_card.dart';
import 'package:wechat/view/chat.dart';
import 'package:wechat/view/friend_applications.dart';
import 'package:wechat/view/home/home.dart';
import 'package:wechat/view/login.dart';
import 'package:wechat/view/need_login.dart';
import 'package:wechat/view/register.dart';
import 'package:wechat/view/server_setting.dart';
import 'package:wechat/view/setting.dart';
import 'package:wechat/view/webview.dart';

class AppRouteSetting extends RouteSetting {
  AppRouteSetting({
    @required String path,
    @required RouteHandler handler,
    Set<String> parameters,
    TransitionType transitionType,
    bool checkLogin = true,
  }) : super(
          path: path,
          handler: _appRouteHandler(handler, checkLogin),
          parameters: parameters,
          transitionType: transitionType,
        );

  static RouteHandler _appRouteHandler(RouteHandler handler, bool checkLogin) =>
      (BuildContext context, Map<String, String> arguments) =>
          (checkLogin && (ownUserInfo.value?.userSession ?? '').isEmpty)
              ? NeedLoginPage()
              : handler(context, arguments);
}

final Set<AppRouteSetting> appRoutes = <AppRouteSetting>{
  AppRouteSetting(
    path: '/',
    handler: (_, __) => (ownUserInfo.value?.userSession ?? '').isNotEmpty
        ? HomePage()
        : LoginPage(),
    transitionType: TransitionType.none,
    checkLogin: false,
  ),
  AppRouteSetting(
    path: '/serverSetting',
    handler: (_, __) => ServerSettingPage(),
    checkLogin: false,
  ),
  AppRouteSetting(
    path: '/register',
    handler: (_, __) => RegisterPage(),
    checkLogin: false,
  ),
  AppRouteSetting(path: '/setting', handler: (_, __) => SettingPage()),
  AppRouteSetting(path: '/addFriend', handler: (_, __) => AddFriendPage()),
  AppRouteSetting(
    path: '/chat',
    handler: (_, Map<String, String> arguments) => ChatPage(
      id: int.parse(arguments['id']),
      title: arguments['title'],
      type: arguments['type'] == 'friend' ? ChatType.friend : ChatType.group,
    ),
    parameters: <String>{'id', 'title', 'type'},
  ),
  AppRouteSetting(
    path: '/webView',
    handler: (_, Map<String, String> arguments) =>
        WebViewPage(arguments['url']),
    parameters: <String>{'url'},
    transitionType: TransitionType.cupertinoFullScreenDialog,
  ),
  AppRouteSetting(
      path: '/businessCard', handler: (_, __) => BusinessCardPage()),
  AppRouteSetting(
    path: '/friendApplications',
    handler: (_, __) => const FriendApplications(),
  ),
};
