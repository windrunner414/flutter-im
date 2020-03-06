import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'friend.g.dart';

enum FriendState {
  @JsonValue(1)
  normal,
  @JsonValue(2)
  black,
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
  final FriendState state;
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
