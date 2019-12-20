import 'package:json_annotation/json_annotation.dart';

part 'api_server_config.g.dart';

@JsonSerializable()
class ApiServerConfig {
  ApiServerConfig({this.domain, int httpPort, int webSocketPort, this.ssl})
      : assert(domain != null),
        assert(httpPort != null),
        assert(webSocketPort != null),
        assert(ssl != null) {
    this.httpPort = httpPort;
    this.webSocketPort = webSocketPort;
  }

  String domain;
  int _httpPort;
  int _webSocketPort;
  bool ssl;

  int get httpPort => _httpPort;
  int get webSocketPort => _webSocketPort;

  set httpPort(int port) => _httpPort = (port > 0 && port <= 65535) ? port : 80;
  set webSocketPort(int port) =>
      _webSocketPort = (port > 0 && port <= 65535) ? port : 9701;

  factory ApiServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ApiServerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ApiServerConfigToJson(this);
}
