import 'dart:convert';

import 'model/server_config.dart';
import 'util/storage.dart';

final _defaultServerConfig = ServerConfig(
    domain: "im.php20.cn", httpPort: 80, webSocketPort: 9701, ssl: false);
const _StorageKey = "server_config";

class Api {
  static const VERIFY_CODE = "Api/Common/VerifyCode/verifyCode";

  static ServerConfig _serverConfig;
  static ServerConfig get serverConfig {
    if (_serverConfig == null) {
      String settings = StorageUtil.get<String>(_StorageKey);
      if (settings == null) {
        _serverConfig = _defaultServerConfig;
      } else {
        _serverConfig = ServerConfig.fromJson(json.decode(settings));
      }
    }
    return _serverConfig;
  }

  static set serverConfig(ServerConfig config) {
    _serverConfig = config;
    StorageUtil.setString(_StorageKey, json.encode(_serverConfig));
  }

  static String get httpBase =>
      (serverConfig.ssl ? "https" : "http") +
      "://" +
      serverConfig.domain +
      ":" +
      serverConfig.httpPort.toString() +
      "/";
  static String get webSocketBase =>
      (serverConfig.ssl ? "wss" : "ws") +
      "://" +
      serverConfig.domain +
      ":" +
      serverConfig.webSocketPort.toString() +
      "/";
}
