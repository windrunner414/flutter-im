import 'package:json_annotation/json_annotation.dart';

part 'server_settings.g.dart';

@JsonSerializable()
class ServerSettings {
  ServerSettings({this.domain, this.httpPort, this.webSocketPort, this.ssl})
      : assert(domain != null),
        assert(httpPort != null),
        assert(webSocketPort != null),
        assert(ssl != null);

  String domain;
  int httpPort;
  int webSocketPort;
  bool ssl;

  factory ServerSettings.fromJson(Map<String, dynamic> json) =>
      _$ServerSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$ServerSettingsToJson(this);
}
