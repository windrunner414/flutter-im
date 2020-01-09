// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_apply.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension FriendApplyCopyWithExtension on FriendApply {
  FriendApply copyWith({
    int addTime,
    int friendApplyId,
    String fromUserAccount,
    String fromUserAvatar,
    int fromUserId,
    String fromUserName,
    String note,
    FriendApplyState state,
    String targetUserAccount,
    String targetUserAvatar,
    String targetUserName,
    String verifyNote,
    int verifyTime,
  }) {
    return FriendApply(
      addTime: addTime ?? this.addTime,
      friendApplyId: friendApplyId ?? this.friendApplyId,
      fromUserAccount: fromUserAccount ?? this.fromUserAccount,
      fromUserAvatar: fromUserAvatar ?? this.fromUserAvatar,
      fromUserId: fromUserId ?? this.fromUserId,
      fromUserName: fromUserName ?? this.fromUserName,
      note: note ?? this.note,
      state: state ?? this.state,
      targetUserAccount: targetUserAccount ?? this.targetUserAccount,
      targetUserAvatar: targetUserAvatar ?? this.targetUserAvatar,
      targetUserName: targetUserName ?? this.targetUserName,
      verifyNote: verifyNote ?? this.verifyNote,
      verifyTime: verifyTime ?? this.verifyTime,
    );
  }
}

extension FriendApplyListCopyWithExtension on FriendApplyList {
  FriendApplyList copyWith({
    List list,
    int total,
  }) {
    return FriendApplyList(
      list: list ?? this.list,
      total: total ?? this.total,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendApply _$FriendApplyFromJson(Map<String, dynamic> json) {
  return FriendApply(
    friendApplyId: json['friendApplyId'] as int,
    fromUserId: json['fromUserId'] as int,
    addTime: json['addTime'] as int,
    state: _$enumDecodeNullable(_$FriendApplyStateEnumMap, json['state']),
    verifyNote: json['verifyNote'] as String,
    verifyTime: json['verifyTime'] as int,
    note: json['note'] as String,
    fromUserAccount: json['fromUserAccount'] as String,
    fromUserName: json['fromUserName'] as String,
    fromUserAvatar: json['fromUserAvatar'] as String,
    targetUserAccount: json['targetUserAccount'] as String,
    targetUserName: json['targetUserName'] as String,
    targetUserAvatar: json['targetUserAvatar'] as String,
  );
}

Map<String, dynamic> _$FriendApplyToJson(FriendApply instance) =>
    <String, dynamic>{
      'friendApplyId': instance.friendApplyId,
      'fromUserId': instance.fromUserId,
      'addTime': instance.addTime,
      'state': _$FriendApplyStateEnumMap[instance.state],
      'verifyNote': instance.verifyNote,
      'verifyTime': instance.verifyTime,
      'note': instance.note,
      'fromUserAccount': instance.fromUserAccount,
      'fromUserName': instance.fromUserName,
      'fromUserAvatar': instance.fromUserAvatar,
      'targetUserAccount': instance.targetUserAccount,
      'targetUserName': instance.targetUserName,
      'targetUserAvatar': instance.targetUserAvatar,
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

const _$FriendApplyStateEnumMap = {
  FriendApplyState.waiting: 0,
  FriendApplyState.accepted: 1,
  FriendApplyState.rejected: 2,
};

FriendApplyList _$FriendApplyListFromJson(Map<String, dynamic> json) {
  return FriendApplyList(
    total: json['total'] as int,
    list: (json['list'] as List)
        ?.map((e) =>
            e == null ? null : FriendApply.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FriendApplyListToJson(FriendApplyList instance) =>
    <String, dynamic>{
      'total': instance.total,
      'list': instance.list,
    };
