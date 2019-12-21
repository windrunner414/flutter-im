import 'package:fluro/fluro.dart' as Fluro show Router;
import 'package:fluro/fluro.dart' show TransitionType, Handler;
import 'package:flutter/material.dart';

import 'view/server_setting.dart';
import 'viewmodel/server_setting.dart';
import 'widget/viewmodel_provider.dart';

enum Page { ServerSetting }

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
      handler: Handler(
        handlerFunc: (_, __) => ViewModelProvider<ServerSettingViewModel>(
          child: ServerSettingPage(),
        ),
      ),
    ),
  };
}

class _RouterNavigatorObserver extends NavigatorObserver {}

abstract class Router {
  static final Fluro.Router _router = Fluro.Router();
  static RouteFactory get generator => _router.generator;
  static final _RouterNavigatorObserver navigatorObserver =
      _RouterNavigatorObserver();

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

    NavigatorState navigator = navigatorObserver.navigator;
    String path = _RoutePage._pages[page].routePath +
        ((parameters ?? []).isNotEmpty ? ("/" + parameters.join("/")) : "");
    if (clearStack) {
      return navigator.pushNamedAndRemoveUntil(path, (check) => false);
    } else if (replace) {
      return navigator.pushReplacementNamed(path);
    } else {
      return navigator.pushNamed(path);
    }
  }

  static bool pop<T extends Object>([T result]) =>
      navigatorObserver.navigator.pop(result);
}
