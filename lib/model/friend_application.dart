import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'friend_application.g.dart';

enum FriendApplicationState {
  @JsonValue(0)
  waiting,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
}

@CopyWith()
@JsonSerializable()
class FriendApplication extends BaseModel {
  const FriendApplication({
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

  factory FriendApplication.fromJson(Map<String, dynamic> json) =>
      _$FriendApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$FriendApplicationToJson(this);

  final int friendApplyId;
  final int fromUserId;
  final int addTime;
  final FriendApplicationState state;
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
class FriendApplicationList extends BaseModel {
  const FriendApplicationList({this.total, this.list});

  factory FriendApplicationList.fromJson(Map<String, dynamic> json) =>
      _$FriendApplicationListFromJson(json);
  Map<String, dynamic> toJson() => _$FriendApplicationListToJson(this);

  final int total;
  final List<FriendApplication> list;
}
