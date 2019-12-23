part of 'api.dart';

final ApiServerConfig _defaultApiServerConfig = ApiServerConfig(
    domain: "im.php20.cn", httpPort: 80, webSocketPort: 9701, ssl: false);

abstract class ApiServer {
  static const _StorageKey = "config.api_server_config";
  static ApiServerConfig _config;
  static ApiServerConfig get config => _config;
  static set config(ApiServerConfig value) {
    _config = value;
    HttpApiClient._instance?._dio?.close(force: true);
    HttpApiClient._instance = HttpApiClient._();
    StorageUtil.setString(_StorageKey, json.encode(_config));
  }

  static String get httpBaseUrl =>
      (config.ssl ? "https" : "http") +
      "://" +
      config.domain +
      ":" +
      config.httpPort.toString() +
      "/";
  static String get webSocketBaseUrl =>
      (config.ssl ? "wss" : "ws") +
      "://" +
      config.domain +
      ":" +
      config.webSocketPort.toString() +
      "/";

  static void init() {
    if (config != null) {
      return;
    }
    String configJson = StorageUtil.get(_StorageKey);
    if (configJson == null) {
      config = _defaultApiServerConfig;
    } else {
      config = ApiServerConfig.fromJson(json.decode(configJson));
    }
  }
}
