// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_args.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension UserMessageArgCopyWithExtension on UserMessageArg {
  UserMessageArg copyWith({
    int addTime,
    String extraData,
    int fromUserId,
    String msg,
    int msgId,
  }) {
    return UserMessageArg(
      addTime: addTime ?? this.addTime,
      extraData: extraData ?? this.extraData,
      fromUserId: fromUserId ?? this.fromUserId,
      msg: msg ?? this.msg,
      msgId: msgId ?? this.msgId,
    );
  }
}

extension UserUnreadMessagesArgCopyWithExtension on UserUnreadMessagesArg {
  UserUnreadMessagesArg copyWith({
    List list,
    int total,
  }) {
    return UserUnreadMessagesArg(
      list: list ?? this.list,
      total: total ?? this.total,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMessageArg _$UserMessageArgFromJson(Map<String, dynamic> json) {
  return UserMessageArg(
    fromUserId: const _FromUserIdConverter().fromJson(json['fromUserId']),
    msgId: json['msgId'] as int,
    extraData: json['extraData'] as String,
    addTime: json['addTime'] as int,
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$UserMessageArgToJson(UserMessageArg instance) =>
    <String, dynamic>{
      'fromUserId': const _FromUserIdConverter().toJson(instance.fromUserId),
      'msgId': instance.msgId,
      'extraData': instance.extraData,
      'addTime': instance.addTime,
      'msg': instance.msg,
    };

UserUnreadMessagesArg _$UserUnreadMessagesArgFromJson(
    Map<String, dynamic> json) {
  return UserUnreadMessagesArg(
    total: json['total'] as int,
    list: (json['list'] as List)
        ?.map((e) => e == null
            ? null
            : UserMessageArg.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserUnreadMessagesArgToJson(
        UserUnreadMessagesArg instance) =>
    <String, dynamic>{
      'total': instance.total,
      'list': instance.list,
    };
