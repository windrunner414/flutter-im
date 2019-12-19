import 'package:json_annotation/json_annotation.dart';

part 'server_config.g.dart';

@JsonSerializable()
class ServerConfig {
  ServerConfig({this.domain, int httpPort, int webSocketPort, this.ssl})
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

  factory ServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ServerConfigToJson(this);
}
