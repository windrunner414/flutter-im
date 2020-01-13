import 'dart:convert';

import 'package:fluro/fluro.dart' as fluro show Router;
import 'package:fluro/fluro.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:wechat/view/add_friend.dart';
import 'package:wechat/view/chat.dart';
import 'package:wechat/view/register.dart';
import 'package:wechat/view/server_setting.dart';
import 'package:wechat/view/setting.dart';
import 'package:wechat/view/webview.dart';

enum Page { serverSetting, register, setting, addFriend, chat, webView }

final Router router = Router._();

class _RoutePage {
  _RoutePage(this.handler, {TransitionType transitionType})
      : assert(handler != null),
        transitionType = transitionType ?? TransitionType.cupertino;

  final _RouteHandler handler;
  final TransitionType transitionType;

  static final Map<Page, _RoutePage> _pages = <Page, _RoutePage>{
    Page.serverSetting: _RoutePage(_RouteHandler((_) => ServerSettingPage())),
    Page.register: _RoutePage(_RouteHandler((_) => RegisterPage())),
    Page.setting: _RoutePage(_RouteHandler((_) => SettingPage())),
    Page.addFriend: _RoutePage(_RouteHandler((_) => AddFriendPage())),
    Page.chat: _RoutePage(
      _RouteHandler(
        (_, {int id, String title, ChatType type}) =>
            ChatPage(id: id, title: title, type: type),
        parameters: <Symbol>{#id, #type, #title},
        encodeParameter: (Symbol name, Object param) {
          switch (name) {
            case #id:
              return param.toString();
            case #type:
              return ChatType.values.indexOf(param as ChatType).toString();
            default:
              return param as String;
          }
        },
        decodeParameter: (Symbol name, String param) {
          switch (name) {
            case #id:
              return int.parse(param);
            case #type:
              return ChatType.values[int.parse(param)];
            default:
              return param;
          }
        },
      ),
    ),
    Page.webView: _RoutePage(
      _RouteHandler(
        (_, {String url}) => WebViewPage(url),
        parameters: <Symbol>{#url},
        encodeParameter: (Symbol name, Object url) =>
            base64Url.encode((url as String).codeUnits),
        decodeParameter: (Symbol name, String url) =>
            String.fromCharCodes(base64Url.decode(url)),
      ),
    ),
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
  for (MapEntry<Page, _RoutePage> entry in _RoutePage._pages.entries) {
    final _RoutePage page = entry.value;
    String routePath = entry.key.toString();
    if (page.handler.parameters != null && page.handler.parameters.isNotEmpty) {
      routePath += '/:' +
          page.handler.parameters
              .map((Symbol name) => name
                  .toString()
                  .substring('Symbol("'.length, name.toString().length - 2))
              .join('/:');
    }
    router._router.define(routePath,
        handler: page.handler, transitionType: page.transitionType);
  }
}

typedef _DecodeParameterFunc = Object Function(Symbol name, String string);
typedef _EncodeParameterFunc = String Function(Symbol name, Object object);

class _RouteHandler extends Handler {
  _RouteHandler(
    this.function, {
    HandlerType type = HandlerType.route,
    this.parameters,
    this.encodeParameter,
    this.decodeParameter,
  })  : assert(function != null),
        super(
          type: type,
          handlerFunc: _convertToFluroHandlerFunc(function, decodeParameter),
        );

  final Function function;
  final Set<Symbol> parameters;
  final _EncodeParameterFunc encodeParameter;
  final _DecodeParameterFunc decodeParameter;

  static HandlerFunc _convertToFluroHandlerFunc(
          Function function, _DecodeParameterFunc decodeParameter) =>
      (BuildContext context, Map<String, List<String>> parameters) {
        final Map<Symbol, Object> _parameters = <Symbol, Object>{};
        for (MapEntry<String, List<String>> entry in parameters.entries) {
          final Symbol key = Symbol(entry.key);
          _parameters[key] = decodeParameter != null
              ? decodeParameter(key, entry.value[0])
              : entry.value[0];
        }
        return Function.apply(function, <dynamic>[context], _parameters)
            as Widget;
      };
}

class Router {
  Router._() : _router = fluro.Router();

  final fluro.Router _router;
  RouteFactory get generator => _router.generator;

  Future<T> push<T>(Page page,
      {Map<Symbol, Object> parameters,
      bool replace = false,
      bool clearStack = false}) {
    assert(replace != null);
    assert(clearStack != null);

    final _RoutePage _page = _RoutePage._pages[page];
    final List<String> _parameters = <String>[];
    if (_page.handler.parameters != null) {
      for (Symbol name in _page.handler.parameters) {
        _parameters.add(_page.handler.encodeParameter != null
            ? _page.handler.encodeParameter(name, parameters[name])
            : parameters[name].toString());
      }
    }

    final NavigatorState navigator = RouterNavigatorObserver().navigator;
    final String path = page.toString() +
        (_parameters.isNotEmpty ? ('/' + _parameters.join('/')) : '');
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
