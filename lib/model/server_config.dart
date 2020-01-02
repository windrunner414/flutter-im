import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'server_config.g.dart';

@JsonSerializable()
@CopyWith()
class ServerConfig extends BaseModel {
  const ServerConfig(
      {this.staticFileDomain,
      this.domain,
      int httpPort,
      int webSocketPort,
      this.ssl})
      : httpPort = (httpPort > 0 && httpPort <= 65535) ? httpPort : 80,
        webSocketPort = (webSocketPort > 0 && webSocketPort <= 65535)
            ? webSocketPort
            : 9701;

  factory ServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ServerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ServerConfigToJson(this);

  final String staticFileDomain;
  final String domain;
  final int httpPort;
  final int webSocketPort;
  final bool ssl;
}
