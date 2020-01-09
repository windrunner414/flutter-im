import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'friend_apply.g.dart';

enum FriendApplyState {
  @JsonValue(0)
  waiting,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
}

@CopyWith()
@JsonSerializable()
class FriendApply extends BaseModel {
  const FriendApply({
    this.friendApplyId,
    this.fromUserId,
    this.addTime,
    this.state,
    this.verifyNote,
    this.verifyTime,
    this.note,
    this.fromUserAccount,
    this.fromUserName,
    this.fromUserAvatar,
    this.targetUserAccount,
    this.targetUserName,
    this.targetUserAvatar,
  });

  factory FriendApply.fromJson(Map<String, dynamic> json) =>
      _$FriendApplyFromJson(json);
  Map<String, dynamic> toJson() => _$FriendApplyToJson(this);

  final int friendApplyId;
  final int fromUserId;
  final int addTime;
  final FriendApplyState state;
  final String verifyNote;
  final int verifyTime;
  final String note;
  final String fromUserAccount;
  final String fromUserName;
  final String fromUserAvatar;
  final String targetUserAccount;
  final String targetUserName;
  final String targetUserAvatar;
}

@CopyWith()
@JsonSerializable()
class FriendApplyList extends BaseModel {
  const FriendApplyList({this.total, this.list});

  factory FriendApplyList.fromJson(Map<String, dynamic> json) =>
      _$FriendApplyListFromJson(json);
  Map<String, dynamic> toJson() => _$FriendApplyListToJson(this);

  final int total;
  final List<FriendApply> list;
}
