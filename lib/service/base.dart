import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:websocket/websocket.dart';
import 'package:wechat/di.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/api_server_config.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';

part 'client/http.dart';
part 'client/websocket.dart';

const ApiServerConfig _DefaultApiServerConfig = ApiServerConfig(
  staticFileDomain: "im.php20.cn",
  domain: "im.php20.cn",
  httpPort: 80,
  webSocketPort: 9701,
  ssl: false,
);

abstract class Service {
  static const _StorageKey = "config.service_config";

  static HttpClient _httpClient;
  static HttpClient get httpClient => _httpClient;

  static WebSocketClient _webSocketClient;
  static WebSocketClient get webSocketClient => _webSocketClient;

  static ApiServerConfig _config;
  static ApiServerConfig get config => _config;
  static set config(ApiServerConfig _value) {
    ApiServerConfig value = _value ?? _DefaultApiServerConfig;
    if (_config != null) {
      // 初始化不用保存
      WorkerUtil.jsonEncode(value)
          .then((String json) => StorageUtil.setString(_StorageKey, json));
    }
    _config = value;
    _updateClient();
  }

  /// 不以/结尾
  static String get httpBaseUrl =>
      (config.ssl ? "https" : "http") +
      "://" +
      config.domain +
      ":" +
      config.httpPort.toString() +
      "/Api";
  static String get webSocketBaseUrl =>
      (config.ssl ? "wss" : "ws") +
      "://" +
      config.domain +
      ":" +
      config.webSocketPort.toString();
  static String get staticFileUrl =>
      (config.ssl ? "https" : "http") + "://" + config.staticFileDomain;

  static Future<void> init() async {
    if (config != null) {
      return;
    }
    String json = StorageUtil.get(_StorageKey);
    config = json == null
        ? null
        : ApiServerConfig.fromJson(await WorkerUtil.jsonDecode(json));
  }

  static void _updateClient() {
    _updateHttpClient();
    _updateWebSocketClient();
  }

  static void _updateHttpClient() {
    if (_httpClient == null) {
      _httpClient = HttpClient(
        baseUrl: httpBaseUrl,
        converter: _HttpConverter(),
        errorConverter: _HttpConverter(),
        interceptors: inject(scope: HttpInterceptorScope),
      );
      return;
    }
    _httpClient._baseUrl = httpBaseUrl;
  }

  /// 可以确保调用时WebSocketClient不在连接状态，只有HomePage加载了才会连接，但只能在HomePage未加载时设置
  static void _updateWebSocketClient() {
    assert(_webSocketClient?.connection == null);
    _webSocketClient = WebSocketClient._(url: webSocketBaseUrl);
  }
}

abstract class BaseService extends ChopperService {}
