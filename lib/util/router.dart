import 'dart:convert';

import 'package:flutter/cupertino.dart';

final Router router = Router._();

enum TransitionType {
  none,
  cupertino,
  cupertinoFullScreenDialog,
}

typedef RouteHandler = Widget Function(
    BuildContext context, Map<String, String> arguments);

class RouteSetting {
  RouteSetting({
    @required this.path,
    @required this.handler,
    Set<String> parameters,
    TransitionType transitionType,
  })  : assert(path != null),
        assert(handler != null),
        parameters = parameters ?? const <String>{},
        transitionType = transitionType ?? TransitionType.cupertino;

  final String path;
  final RouteHandler handler;
  final Set<String> parameters;
  final TransitionType transitionType;
}

class RouterNavigatorObserver extends NavigatorObserver {
  factory RouterNavigatorObserver() =>
      _instance ??= RouterNavigatorObserver._();

  RouterNavigatorObserver._();

  static RouterNavigatorObserver _instance;
}

class Router {
  Router._() : _routes = <String, RouteSetting>{};

  final Map<String, RouteSetting> _routes;

  void addRoute(RouteSetting route, {bool replaceIfExists = false}) {
    if (!RegExp(r'^/[a-zA-Z0-9/]*$').hasMatch(route.path)) {
      throw ArgumentError.value(route.path, 'path', 'Invalid path');
    }
    if (!replaceIfExists && _routes.containsKey(route.path)) {
      throw ArgumentError.value(route.path, 'path', 'Route already exists');
    }
    _routes[route.path] = route;
  }

  void addRoutes(Set<RouteSetting> routes, {bool replaceIfExists = false}) {
    for (RouteSetting route in routes) {
      addRoute(route, replaceIfExists: replaceIfExists);
    }
  }

  Future<T> push<T extends Object>(String path,
          {Map<String, String> arguments}) =>
      RouterNavigatorObserver().navigator.pushNamed(path, arguments: arguments);

  Future<T> pushReplacement<T extends Object>(String path,
          {Map<String, String> arguments}) =>
      RouterNavigatorObserver()
          .navigator
          .pushReplacementNamed(path, arguments: arguments);

  Future<T> pushAndRemoveUntil<T extends Object>(
    String path,
    RoutePredicate predicate, {
    Map<String, String> arguments,
  }) =>
      RouterNavigatorObserver()
          .navigator
          .pushNamedAndRemoveUntil(path, predicate, arguments: arguments);

  void pop<T extends Object>([T result]) =>
      RouterNavigatorObserver().navigator.pop(result);

  Future<bool> maybePop<T extends Object>([T result]) =>
      RouterNavigatorObserver().navigator.maybePop(result);

  void popUntil(RoutePredicate predicate) =>
      RouterNavigatorObserver().navigator.popUntil(predicate);

  Route<T> generator<T>(RouteSettings settings) {
    String path = settings.name;
    Map<String, String> arguments;

    final int separatorPosition = path.indexOf(',');
    if (separatorPosition != -1) {
      if (settings.arguments != null) {
        return null;
      }
      final String pathArguments = path.substring(separatorPosition + 1);
      path = path.substring(0, separatorPosition);
      try {
        arguments = (jsonDecode(utf8.decode(base64Decode(pathArguments)))
                as Map<String, dynamic>)
            .cast();
      } catch (error) {
        return null;
      }
    } else {
      try {
        arguments = settings.arguments as Map<String, String>;
      } catch (error) {
        return null;
      }
    }
    arguments ??= const <String, String>{};

    final RouteSetting route = _routes[path];
    if (route == null) {
      return null;
    }
    if (arguments.length != route.parameters.length) {
      return null;
    }
    for (String key in route.parameters) {
      if (!arguments.containsKey(key)) {
        return null;
      }
    }

    return _buildRoute(
      settings: settings.copyWith(
          name: arguments.isEmpty
              ? path
              : path +
                  ',${base64UrlEncode(utf8.encode(jsonEncode(arguments)))}'),
      transitionType: route.transitionType,
      builder: (BuildContext context) => route.handler(context, arguments),
    );
  }

  Route<T> _buildRoute<T>({
    @required RouteSettings settings,
    @required TransitionType transitionType,
    @required WidgetBuilder builder,
  }) {
    switch (transitionType) {
      case TransitionType.none:
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (BuildContext context, _, __) => builder(context),
          transitionDuration: Duration.zero,
        );
      case TransitionType.cupertino:
        return CupertinoPageRoute<T>(
          settings: settings,
          builder: builder,
        );
      case TransitionType.cupertinoFullScreenDialog:
        return CupertinoPageRoute<T>(
          settings: settings,
          fullscreenDialog: true,
          builder: builder,
        );
      default:
        return null;
    }
  }
}
