import 'package:fluro/fluro.dart' as Fluro show Router;
import 'package:fluro/fluro.dart' show TransitionType, Handler;
import 'package:flutter/material.dart';
import 'package:wechat/view/server_setting.dart';
import 'package:wechat/view/setting.dart';

enum Page { ServerSetting, Setting }

class _RoutePage {
  final String routePath;
  final List<String> parameters;
  final Handler handler;
  final TransitionType transitionType;

  _RoutePage(
      {@required this.routePath,
      this.parameters,
      @required this.handler,
      transitionType})
      : assert(routePath != null),
        assert(handler != null),
        this.transitionType = transitionType ?? TransitionType.cupertino;

  static final Map<Page, _RoutePage> _pages = {
    Page.ServerSetting: _RoutePage(
        routePath: "/serverSetting",
        transitionType: TransitionType.cupertinoFullScreenDialog,
        handler: Handler(handlerFunc: (_, __) => ServerSettingPage())),
    Page.Setting: _RoutePage(
        routePath: "/setting",
        handler: Handler(handlerFunc: (_, __) => SettingPage()))
  };
}

class RouterNavigatorObserver extends NavigatorObserver {
  static RouterNavigatorObserver _instance;

  factory RouterNavigatorObserver() {
    if (_instance == null) {
      _instance = RouterNavigatorObserver._();
    }

    return _instance;
  }

  RouterNavigatorObserver._();
}

abstract class Router {
  static final Fluro.Router _router = Fluro.Router();
  static RouteFactory get generator => _router.generator;

  static void init() {
    for (_RoutePage page in _RoutePage._pages.values) {
      String routePath = page.routePath;
      if (page.parameters != null && page.parameters.isNotEmpty) {
        routePath += "/:" + page.parameters.join("/:");
      }
      _router.define(routePath,
          handler: page.handler, transitionType: page.transitionType);
    }
  }

  static Future<T> navigateTo<T extends Object>(Page page,
      {List<String> parameters,
      bool replace = false,
      bool clearStack = false}) {
    assert(replace != null);
    assert(clearStack != null);

    NavigatorState navigator = RouterNavigatorObserver().navigator;
    String path = _RoutePage._pages[page].routePath +
        ((parameters ?? []).isNotEmpty ? ("/" + parameters.join("/")) : "");
    if (clearStack) {
      return navigator.pushNamedAndRemoveUntil(path, (_) => false);
    } else if (replace) {
      return navigator.pushReplacementNamed(path);
    } else {
      return navigator.pushNamed(path);
    }
  }

  static bool pop<T extends Object>([T result]) =>
      RouterNavigatorObserver().navigator.pop(result);
}
