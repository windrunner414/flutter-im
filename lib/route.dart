import 'package:fluro/fluro.dart' as fluro show Router;
import 'package:fluro/fluro.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:wechat/view/server_setting.dart';
import 'package:wechat/view/setting.dart';

enum Page { ServerSetting, Setting }

final Router router = Router._();

class _RoutePage {
  _RoutePage(
      {@required this.routePath,
      this.parameters,
      @required this.handler,
      TransitionType transitionType})
      : assert(routePath != null),
        assert(handler != null),
        transitionType = transitionType ?? TransitionType.cupertino;

  final String routePath;
  final List<String> parameters;
  final Handler handler;
  final TransitionType transitionType;

  static final Map<Page, _RoutePage> _pages = <Page, _RoutePage>{
    Page.ServerSetting: _RoutePage(
        routePath: '/serverSetting',
        transitionType: TransitionType.cupertinoFullScreenDialog,
        handler: Handler(handlerFunc: (_, __) => ServerSettingPage())),
    Page.Setting: _RoutePage(
        routePath: '/setting',
        handler: Handler(handlerFunc: (_, __) => SettingPage()))
  };
}

class RouterNavigatorObserver extends NavigatorObserver {
  factory RouterNavigatorObserver() {
    _instance ??= RouterNavigatorObserver._();
    return _instance;
  }

  RouterNavigatorObserver._();

  static RouterNavigatorObserver _instance;
}

void initRoute() {
  for (_RoutePage page in _RoutePage._pages.values) {
    String routePath = page.routePath;
    if (page.parameters != null && page.parameters.isNotEmpty) {
      routePath += '/:' + page.parameters.join('/:');
    }
    router._router.define(routePath,
        handler: page.handler, transitionType: page.transitionType);
  }
}

class Router {
  Router._() : _router = fluro.Router();

  final fluro.Router _router;
  RouteFactory get generator => _router.generator;

  Future<T> push<T>(Page page,
      {List<String> parameters,
      bool replace = false,
      bool clearStack = false}) {
    assert(replace != null);
    assert(clearStack != null);

    final NavigatorState navigator = RouterNavigatorObserver().navigator;
    final String path = _RoutePage._pages[page].routePath +
        ((parameters ?? <String>[]).isNotEmpty
            ? ('/' + parameters.join('/'))
            : '');
    if (clearStack) {
      return navigator.pushNamedAndRemoveUntil(path, (_) => false);
    } else if (replace) {
      return navigator.pushReplacementNamed(path);
    } else {
      return navigator.pushNamed(path);
    }
  }

  bool pop<T>([T result]) => RouterNavigatorObserver().navigator.pop(result);
}
