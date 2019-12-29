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
    int webSocketPort,
  }) {
    return ApiServerConfig(
      domain: domain ?? this.domain,
      httpPort: httpPort ?? this.httpPort,
      ssl: ssl ?? this.ssl,
      webSocketPort: webSocketPort ?? this.webSocketPort,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiServerConfig _$ApiServerConfigFromJson(Map<String, dynamic> json) {
  return ApiServerConfig(
    domain: json['domain'] as String,
    httpPort: json['httpPort'] as int,
    webSocketPort: json['webSocketPort'] as int,
    ssl: json['ssl'] as bool,
  );
}

Map<String, dynamic> _$ApiServerConfigToJson(ApiServerConfig instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'httpPort': instance.httpPort,
      'webSocketPort': instance.webSocketPort,
      'ssl': instance.ssl,
    };
