// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension ConversationCopyWithExtension on Conversation {
  Conversation copyWith({
    String desc,
    int fromId,
    int msgId,
    ConversationType type,
    int unreadMsgCount,
    int updateAt,
  }) {
    return Conversation(
      desc: desc ?? this.desc,
      fromId: fromId ?? this.fromId,
      msgId: msgId ?? this.msgId,
      type: type ?? this.type,
      unreadMsgCount: unreadMsgCount ?? this.unreadMsgCount,
      updateAt: updateAt ?? this.updateAt,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return Conversation(
    fromId: json['fromId'] as int,
    type: _$enumDecodeNullable(_$ConversationTypeEnumMap, json['type']),
    desc: json['desc'] as String,
    updateAt: json['updateAt'] as int,
    unreadMsgCount: json['unreadMsgCount'] as int,
    msgId: json['msgId'] as int,
  );
}

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'fromId': instance.fromId,
      'type': _$ConversationTypeEnumMap[instance.type],
      'desc': instance.desc,
      'updateAt': instance.updateAt,
      'unreadMsgCount': instance.unreadMsgCount,
      'msgId': instance.msgId,
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

const _$ConversationTypeEnumMap = {
  ConversationType.user: 0,
  ConversationType.group: 1,
};
