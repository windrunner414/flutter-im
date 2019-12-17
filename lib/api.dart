import 'dart:convert';

import 'package:wechat/model/server_settings.dart';
import 'package:wechat/util/storage.dart';

final _defaultServerSettings = ServerSettings(
    domain: "im.php20.cn", httpPort: 80, webSocketPort: 9701, ssl: false);
const _StorageKey = "server_settings";

class Api {
  static ServerSettings _serverSettings;
  static ServerSettings get serverSettings {
    if (_serverSettings == null) {
      String settings = StorageUtil.get<String>(_StorageKey);
      if (settings == null) {
        _serverSettings = _defaultServerSettings;
      } else {
        _serverSettings = ServerSettings.fromJson(json.decode(settings));
      }
    }
    return _serverSettings;
  }

  static set serverSettings(ServerSettings settings) {
    _serverSettings = settings;
    StorageUtil.setString(_StorageKey, json.encode(_serverSettings));
  }

  static String get httpBase =>
      (serverSettings.ssl ? "https" : "http") +
      "://" +
      serverSettings.domain +
      ":" +
      serverSettings.httpPort.toString() +
      "/";
  static String get webSocketBase =>
      (serverSettings.ssl ? "wss" : "ws") +
      "://" +
      serverSettings.domain +
      ":" +
      serverSettings.webSocketPort.toString() +
      "/";
}
