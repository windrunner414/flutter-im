import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:wechat/di.dart';
import 'package:wechat/model/server_config.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';

import 'client/http.dart';
import 'client/websocket.dart';

const ServerConfig _DefaultApiServerConfig = ServerConfig(
  staticFileDomain: 'im.php20.cn',
  domain: 'im.php20.cn',
  httpPort: 80,
  webSocketPort: 9701,
  ssl: false,
);

const String _StorageKey = 'config.service_config';

HttpClient _httpClient;
HttpClient get httpClient => _httpClient;

WebSocketClient _webSocketClient;
WebSocketClient get webSocketClient => _webSocketClient;

ServerConfig _serverConfig;
ServerConfig get serverConfig => _serverConfig;
set serverConfig(ServerConfig _value) {
  final ServerConfig value = _value ?? _DefaultApiServerConfig;
  if (_serverConfig != null) {
    // 初始化不用保存
    executeJsonEncode(value)
        .then((String json) => StorageUtil.setString(_StorageKey, json));
  }
  _serverConfig = value;
  _updateClient();
}

/// 不以/结尾
String get httpBaseUrl =>
    (serverConfig.ssl ? 'https' : 'http') +
    '://' +
    serverConfig.domain +
    ':' +
    serverConfig.httpPort.toString() +
    '/Api';
String get webSocketBaseUrl =>
    (serverConfig.ssl ? 'wss' : 'ws') +
    '://' +
    serverConfig.domain +
    ':' +
    serverConfig.webSocketPort.toString();
String get staticFileBaseUrl =>
    (serverConfig.ssl ? 'https' : 'http') +
    '://' +
    serverConfig.staticFileDomain;

Future<void> initService() async {
  if (serverConfig != null) {
    return;
  }
  final String json = StorageUtil.get(_StorageKey);
  serverConfig = json == null
      ? null
      : ServerConfig.fromJson(await executeJsonDecode(json));
}

void _updateClient() {
  _httpClient ??= HttpClient(
    interceptors: inject(scope: HttpInterceptorScope),
  );
  _httpClient.baseUrl = httpBaseUrl;

  assert(_webSocketClient?.connection == null);
  _webSocketClient = WebSocketClient(url: webSocketBaseUrl);
}

abstract class BaseService extends ChopperService {}
