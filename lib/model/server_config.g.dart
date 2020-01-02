// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ServerConfigCopyWithExtension on ServerConfig {
  ServerConfig copyWith({
    String domain,
    int httpPort,
    bool ssl,
    String staticFileDomain,
    int webSocketPort,
  }) {
    return ServerConfig(
      domain: domain ?? this.domain,
      httpPort: httpPort ?? this.httpPort,
      ssl: ssl ?? this.ssl,
      staticFileDomain: staticFileDomain ?? this.staticFileDomain,
      webSocketPort: webSocketPort ?? this.webSocketPort,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) {
  return ServerConfig(
    staticFileDomain: json['staticFileDomain'] as String,
    domain: json['domain'] as String,
    httpPort: json['httpPort'] as int,
    webSocketPort: json['webSocketPort'] as int,
    ssl: json['ssl'] as bool,
  );
}

Map<String, dynamic> _$ServerConfigToJson(ServerConfig instance) =>
    <String, dynamic>{
      'staticFileDomain': instance.staticFileDomain,
      'domain': instance.domain,
      'httpPort': instance.httpPort,
      'webSocketPort': instance.webSocketPort,
      'ssl': instance.ssl,
    };
