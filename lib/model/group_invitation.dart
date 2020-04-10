import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_invitation.g.dart';

enum GroupInvitationState {
  @JsonValue(0)
  waiting,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
}

@JsonSerializable()
@CopyWith()
class GroupInvitation {
  GroupInvitation({
    this.groupId,
    this.state,
    this.userId,
    this.groupName,
    this.userAvatar,
    this.userName,
    this.userAccount,
    this.manageUserId,
    this.addTime,
    this.applyType,
    this.groupApplyId,
    this.manageNote,
    this.note,
    this.verifyTime,
  });

  factory GroupInvitation.fromJson(Map<String, dynamic> json) =>
      _$GroupInvitationFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInvitationToJson(this);

  final int groupApplyId;
  final int userId;
  final int groupId;
  final int manageUserId;
  final int addTime;
  final String note;
  final GroupInvitationState state;
  final String manageNote;
  final int verifyTime;
  final int applyType;
  final String groupName;
  final String userName;
  final String userAccount;
  final String userAvatar;
}

@JsonSerializable()
@CopyWith()
class GroupInvitationList {
  GroupInvitationList({this.total, this.list});

  factory GroupInvitationList.fromJson(Map<String, dynamic> json) =>
      _$GroupInvitationListFromJson(json);
  Map<String, dynamic> toJson() => _$GroupInvitationListToJson(this);

  final int total;
  final List<GroupInvitation> list;
}
