// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension MessageCopyWithExtension on Message {
  Message copyWith({
    int fromUserId,
    String msg,
    int msgId,
    MessageType type,
  }) {
    return Message(
      fromUserId: fromUserId ?? this.fromUserId,
      msg: msg ?? this.msg,
      msgId: msgId ?? this.msgId,
      type: type ?? this.type,
    );
  }
}

extension UserUnreadMsgNumCopyWithExtension on UserUnreadMsgNum {
  UserUnreadMsgNum copyWith({
    int fromUserId,
    int num,
  }) {
    return UserUnreadMsgNum(
      fromUserId: fromUserId ?? this.fromUserId,
      num: num ?? this.num,
    );
  }
}

extension UserUnreadMsgSumCopyWithExtension on UserUnreadMsgSum {
  UserUnreadMsgSum copyWith({
    List list,
    int total,
  }) {
    return UserUnreadMsgSum(
      list: list ?? this.list,
      total: total ?? this.total,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    fromUserId: json['fromUserId'] as int,
    msgId: json['msgId'] as int,
    msg: json['msg'] as String,
    type: _$enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'msgId': instance.msgId,
      'type': _$MessageTypeEnumMap[instance.type],
      'msg': instance.msg,
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

UserUnreadMsgNum _$UserUnreadMsgNumFromJson(Map<String, dynamic> json) {
  return UserUnreadMsgNum(
    fromUserId: json['fromUserId'] as int,
    num: json['num'] as int,
  );
}

Map<String, dynamic> _$UserUnreadMsgNumToJson(UserUnreadMsgNum instance) =>
    <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'num': instance.num,
    };

UserUnreadMsgSum _$UserUnreadMsgSumFromJson(Map<String, dynamic> json) {
  return UserUnreadMsgSum(
    total: json['total'] as int,
    list: (json['list'] as List)
        ?.map((e) => e == null
            ? null
            : UserUnreadMsgNum.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserUnreadMsgSumToJson(UserUnreadMsgSum instance) =>
    <String, dynamic>{
      'total': instance.total,
      'list': instance.list,
    };
