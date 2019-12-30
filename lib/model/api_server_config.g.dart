// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_server_config.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ApiServerConfigCopyWithExtension on ApiServerConfig {
  ApiServerConfig copyWith({
    String domain,
    int httpPort,
    bool ssl,
    String staticFileDomain,
    int webSocketPort,
  }) {
    return ApiServerConfig(
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

ApiServerConfig _$ApiServerConfigFromJson(Map<String, dynamic> json) {
  return ApiServerConfig(
    staticFileDomain: json['staticFileDomain'] as String,
    domain: json['domain'] as String,
    httpPort: json['httpPort'] as int,
    webSocketPort: json['webSocketPort'] as int,
    ssl: json['ssl'] as bool,
  );
}

Map<String, dynamic> _$ApiServerConfigToJson(ApiServerConfig instance) =>
    <String, dynamic>{
      'staticFileDomain': instance.staticFileDomain,
      'domain': instance.domain,
      'httpPort': instance.httpPort,
      'webSocketPort': instance.webSocketPort,
      'ssl': instance.ssl,
    };
