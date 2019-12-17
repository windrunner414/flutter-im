import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:wechat/util/storage.dart';

const _DefaultServerSettings = <String, String>{
  "domain": "im.php20.cn", // 域名
  "http_port": "80", // http端口
  "websocket_port": "9701", // websocket端口
  "ssl": "0", // 1开启ssl, 0关闭
};
const _StorageKey = "server_settings";

class Api {
  static Map<String, String> _serverSettings;
  static Map<String, String> get serverSettings {
    if (_serverSettings == null) {
      _serverSettings =
          json.decode(StorageUtil.get<String>(_StorageKey) ?? "null") ??
              _DefaultServerSettings;
    }
    return _serverSettings;
  }

  static bool get isSsl => serverSettings["ssl"] == "1";
  static String get domain => serverSettings["domain"];
  static String get httpPort => serverSettings["http_port"];
  static String get websocketPort => serverSettings["websocket_port"];

  static String get httpBase =>
      (isSsl ? "https" : "http") + "://" + domain + ":" + httpPort + "/";
  static String get webSocketBase =>
      (isSsl ? "wss" : "ws") + "://" + domain + ":" + httpPort + "/";

  static void setServerSettings(
      {@required String domain,
      @required String httpPort,
      @required String webSocketPort,
      @required bool isSsl}) {
    assert(domain != null);
    assert(httpPort != null);
    assert(webSocketPort != null);
    assert(isSsl != null);

    _serverSettings = <String, String>{
      "domain": domain,
      "http_port": httpPort,
      "websocket_port": websocketPort,
      "ssl": isSsl ? "1" : "0"
    };
    StorageUtil.setString(_StorageKey, json.encode(_serverSettings));
  }
}
