import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/view/add_friend.dart';
import 'package:wechat/view/black_list.dart';
import 'package:wechat/view/business_card.dart';
import 'package:wechat/view/chat.dart';
import 'package:wechat/view/create_group.dart';
import 'package:wechat/view/edit_profile.dart';
import 'package:wechat/view/friend_applications.dart';
import 'package:wechat/view/home/home.dart';
import 'package:wechat/view/joined_group_list.dart';
import 'package:wechat/view/login.dart';
import 'package:wechat/view/need_login.dart';
import 'package:wechat/view/register.dart';
import 'package:wechat/view/scan_qr.dart';
import 'package:wechat/view/server_setting.dart';
import 'package:wechat/view/setting.dart';
import 'package:wechat/view/user.dart';
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
      type: arguments['type'] == 'friend'
          ? ConversationType.friend
          : ConversationType.group,
    ),
    parameters: <String>{'id', 'type'},
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
    handler: (_, __) => FriendApplicationsPage(),
  ),
  AppRouteSetting(path: '/createGroup', handler: (_, __) => CreateGroupPage()),
  AppRouteSetting(
      path: '/joinedGroupList', handler: (_, __) => JoinedGroupListPage()),
  AppRouteSetting(
    path: '/user',
    handler: (_, Map<String, String> arguments) => UserPage(
      userId: int.tryParse(arguments['userId']),
      groupId: arguments['groupId'] == null
          ? null
          : int.tryParse(arguments['groupId']),
    ),
    parameters: <String>{'userId', 'groupId'},
  ),
  AppRouteSetting(path: '/scanQrCode', handler: (_, __) => ScanQrPage()),
  AppRouteSetting(path: '/blackList', handler: (_, __) => BlackListPage()),
  AppRouteSetting(
    path: '/editProfile',
    handler: (_, __) => EditProfilePage(),
  ),
};
