// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension WebSocketMessageCopyWithExtension<T> on WebSocketMessage<T> {
  WebSocketMessage copyWith({
    T args,
    int flagId,
    String msg,
    MessageType msgType,
    int op,
  }) {
    return WebSocketMessage(
      args: args ?? this.args,
      flagId: flagId ?? this.flagId,
      msg: msg ?? this.msg,
      msgType: msgType ?? this.msgType,
      op: op ?? this.op,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketMessage<T> _$WebSocketMessageFromJson<T>(Map<String, dynamic> json) {
  return WebSocketMessage<T>(
    op: json['op'] as int,
    args: ModelGenericJsonConverter<T>().fromJson(json['args']),
    msg: json['msg'] as String,
    msgType: _$enumDecodeNullable(_$MessageTypeEnumMap, json['msgType']),
    flagId: json['flagId'] as int,
  );
}

Map<String, dynamic> _$WebSocketMessageToJson<T>(
        WebSocketMessage<T> instance) =>
    <String, dynamic>{
      'op': instance.op,
      'args': ModelGenericJsonConverter<T>().toJson(instance.args),
      'msg': instance.msg,
      'msgType': _$MessageTypeEnumMap[instance.msgType],
      'flagId': instance.flagId,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MessageTypeEnumMap = {
  MessageType.text: 1,
  MessageType.image: 2,
  MessageType.audio: 3,
  MessageType.video: 4,
  MessageType.system: 5,
};
