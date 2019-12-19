import 'package:fluro/fluro.dart' as Fluro show Router;
import 'package:fluro/fluro.dart' show TransitionType, Handler;
import 'package:flutter/material.dart';

import 'view/server_setting.dart';
import 'viewmodel/provider.dart';
import 'viewmodel/server_setting.dart';

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

class Router {
  static Fluro.Router _router;

  Router._();

  static void init() {
    if (_router != null) {
      return;
    }
    _router = Fluro.Router();
    for (_RoutePage page in _RoutePage._pages.values) {
      String routePath = page.routePath;
      if (page.parameters != null && page.parameters.length > 0) {
        routePath += "/:" + page.parameters.join("/:");
      }
      _router.define(routePath,
          handler: page.handler, transitionType: page.transitionType);
    }
  }

  static Future navigateTo(BuildContext context, Page page,
          {List<String> parameters,
          bool replace = false,
          bool clearStack = false,
          TransitionType transition,
          Duration transitionDuration = const Duration(milliseconds: 250),
          RouteTransitionsBuilder transitionBuilder}) =>
      _router.navigateTo(
          context,
          _RoutePage._pages[page].routePath +
              (parameters != null ? ("/" + parameters.join("/")) : ""),
          replace: replace,
          clearStack: clearStack,
          transition: transition,
          transitionBuilder: transitionBuilder,
          transitionDuration: transitionDuration);

  static bool pop<T extends Object>(BuildContext context, [T result]) =>
      Navigator.pop(context, result);
}
