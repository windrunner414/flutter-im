import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'user.g.dart';

enum UserState {
  @JsonValue(0)
  disabled,
  @JsonValue(1)
  normal,
}

@JsonSerializable()
@CopyWith()
class User extends BaseModel {
  const User({
    this.userAccount,
    this.userName,
    this.userId,
    this.userAvatar,
    this.state,
    this.userSession,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  final String userAccount;
  final String userName;
  final int userId;
  final String userAvatar;
  final UserState state;
  final String userSession;
}

@JsonSerializable()
@CopyWith()
class UserList extends BaseModel {
  const UserList({this.total, this.list});

  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);
  Map<String, dynamic> toJson() => _$UserListToJson(this);

  final int total;
  final List<User> list;
}

@JsonSerializable()
@CopyWith()
class Friend extends BaseModel {
  Friend({
    this.friendId,
    this.targetUserName,
    this.userAvatar,
    this.addTime,
    this.state,
    this.targetUserAccount,
    this.remark,
    this.targetUserId,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);

  final int friendId;
  final int targetUserId;
  final String remark;
  final int addTime;
  final int state;
  final String targetUserName;
  final String targetUserAccount;
  final String userAvatar;

  String get showName => (remark ?? '').isEmpty ? targetUserName : remark;
}

@JsonSerializable()
@CopyWith()
class FriendList extends BaseModel {
  FriendList({this.total, this.list});

  factory FriendList.fromJson(Map<String, dynamic> json) =>
      _$FriendListFromJson(json);
  Map<String, dynamic> toJson() => _$FriendListToJson(this);

  final int total;
  final List<Friend> list;
}
