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
  }) {
    return Message(
      fromUserId: fromUserId ?? this.fromUserId,
      msg: msg ?? this.msg,
      msgId: msgId ?? this.msgId,
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
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'fromUserId': instance.fromUserId,
      'msgId': instance.msgId,
      'msg': instance.msg,
    };
