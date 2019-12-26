import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'api_server_config.g.dart';

@JsonSerializable()
@CopyWith()
class ApiServerConfig extends BaseModel {
  ApiServerConfig({this.domain, int httpPort, int webSocketPort, this.ssl})
      : this.httpPort = (httpPort > 0 && httpPort <= 65535) ? httpPort : 80,
        this.webSocketPort = (webSocketPort > 0 && webSocketPort <= 65535)
            ? webSocketPort
            : 9701;

  final String domain;
  final int httpPort;
  final int webSocketPort;
  final bool ssl;

  factory ApiServerConfig.fromJson(Map<String, dynamic> json) =>
      _$ApiServerConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ApiServerConfigToJson(this);
}
