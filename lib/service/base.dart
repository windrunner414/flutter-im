import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:wechat/model/server_config.dart';
import 'package:wechat/service/interceptors/base.dart';
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
    worker
        .jsonEncode(value)
        .then((String json) => StorageUtil.setString(_StorageKey, json));
  }
  _serverConfig = value;
  _updateClient();
}

/// 不以/结尾
String get httpBaseUrl => Uri(
      scheme: serverConfig.ssl ? 'https' : 'http',
      host: serverConfig.domain,
      port: serverConfig.httpPort,
      path: '/Api',
    ).toString();
String get webSocketBaseUrl => Uri(
      scheme: serverConfig.ssl ? 'wss' : 'ws',
      host: serverConfig.domain,
      port: serverConfig.webSocketPort,
    ).toString();
String get staticFileBaseUrl => Uri(
      scheme: serverConfig.ssl ? 'https' : 'http',
      host: serverConfig.domain,
    ).toString();

Future<void> initService() async {
  if (serverConfig != null) {
    return;
  }
  final String json = StorageUtil.get(_StorageKey);
  serverConfig = json == null
      ? null
      : ServerConfig.fromJson(await worker.jsonDecode(json));
}

void _updateClient() {
  final WebClientInterceptors interceptors = inject();
  assert(interceptors.checkValid());

  _httpClient ??= HttpClient(
    timeout: const Duration(seconds: 15),
    interceptors: interceptors.interceptors,
  );
  _httpClient.baseUrl = httpBaseUrl;

  _webSocketClient ??= WebSocketClient();
}

abstract class BaseService extends ChopperService {}
