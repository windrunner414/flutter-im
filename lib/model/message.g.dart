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
