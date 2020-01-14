import 'package:flutter/cupertino.dart';
import 'package:wechat/view/add_friend.dart';
import 'package:wechat/view/chat.dart';
import 'package:wechat/view/register.dart';
import 'package:wechat/view/server_setting.dart';
import 'package:wechat/view/setting.dart';
import 'package:wechat/view/webview.dart';

enum Page { serverSetting, register, setting, addFriend, chat, webView }

final Router router = Router._();

void initRoute() {
  router._routes = <Page, _Route>{
    Page.serverSetting: _Route((_) => ServerSettingPage()),
    Page.register: _Route((_) => RegisterPage()),
    Page.setting: _Route((_) => SettingPage()),
    Page.addFriend: _Route((_) => AddFriendPage()),
    Page.chat: _Route(
      (_, {int id, String title, ChatType type}) =>
          ChatPage(id: id, title: title, type: type),
      parameters: <Symbol>{#id, #title, #type},
    ),
    Page.webView: _Route(
      (_, {String url}) => WebViewPage(url),
      parameters: <Symbol>{#url},
      transitionType: TransitionType.cupertinoFullScreenDialog,
    ),
  };
}

enum TransitionType {
  cupertino,
  cupertinoFullScreenDialog,
}

class _Route {
  _Route(
    this.handler, {
    Set<Symbol> parameters,
    TransitionType transitionType,
  })  : assert(handler != null),
        parameters = parameters ?? const <Symbol>{},
        transitionType = transitionType ?? TransitionType.cupertino;

  final Function handler;
  final Set<Symbol> parameters;
  final TransitionType transitionType;
}

class RouterNavigatorObserver extends NavigatorObserver {
  factory RouterNavigatorObserver() =>
      _instance ??= RouterNavigatorObserver._();

  RouterNavigatorObserver._();

  static RouterNavigatorObserver _instance;
}

class Router {
  Router._();

  Map<Page, _Route> _routes = <Page, _Route>{};

  Future<T> push<T>(
    Page page, {
    Map<Symbol, Object> parameters,
    bool replace = false,
    RoutePredicate removeUntil,
  }) {
    assert(replace != null);
    assert(replace == false || removeUntil == null);

    final _Route route = _routes[page];
    if (route == null) {
      throw ArgumentError.value(page, 'page', 'Route[$page] not found');
    }

    parameters = parameters ?? const <Symbol, Object>{};
    if (route.parameters.length != parameters.length) {
      throw ArgumentError(
          'Route[$page] expected ${route.parameters.length} arguments, but got ${parameters.length}');
    }
    for (Symbol parameter in route.parameters) {
      if (!parameters.containsKey(parameter)) {
        throw ArgumentError('Route[$page] required parameter[$parameter]');
      }
    }

    final PageRoute<T> pageRoute = CupertinoPageRoute<T>(
      fullscreenDialog:
          route.transitionType == TransitionType.cupertinoFullScreenDialog,
      builder: (BuildContext context) =>
          Function.apply(route.handler, <dynamic>[context], parameters)
              as Widget,
    );

    final NavigatorState navigator = RouterNavigatorObserver().navigator;
    if (removeUntil != null) {
      return navigator.pushAndRemoveUntil(pageRoute, removeUntil);
    } else if (replace) {
      return navigator.pushReplacement(pageRoute);
    } else {
      return navigator.push(pageRoute);
    }
  }

  bool pop<T>([T result]) => RouterNavigatorObserver().navigator.pop(result);
}
