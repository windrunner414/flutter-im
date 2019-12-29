// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension UserCopyWithExtension on User {
  User copyWith({
    UserState state,
    String userAccount,
    String userAvatar,
    int userId,
    String userName,
    String userSession,
  }) {
    return User(
      state: state ?? this.state,
      userAccount: userAccount ?? this.userAccount,
      userAvatar: userAvatar ?? this.userAvatar,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userSession: userSession ?? this.userSession,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userAccount: json['userAccount'] as String,
    userName: json['userName'] as String,
    userId: json['userId'] as int,
    userAvatar: json['userAvatar'] as String,
    state: _$enumDecodeNullable(_$UserStateEnumMap, json['state']),
    userSession: json['userSession'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userAccount': instance.userAccount,
      'userName': instance.userName,
      'userId': instance.userId,
      'userAvatar': instance.userAvatar,
      'state': _$UserStateEnumMap[instance.state],
      'userSession': instance.userSession,
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

const _$UserStateEnumMap = {
  UserState.disabled: 0,
  UserState.normal: 1,
};
