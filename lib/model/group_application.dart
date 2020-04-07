import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_application.g.dart';

enum GroupApplicationState {
  @JsonValue(0)
  waiting,
  @JsonValue(1)
  accepted,
  @JsonValue(2)
  rejected,
}

@JsonSerializable()
@CopyWith()
class GroupApplication {
  GroupApplication({
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

  factory GroupApplication.fromJson(Map<String, dynamic> json) =>
      _$GroupApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$GroupApplicationToJson(this);

  final int groupApplyId;
  final int userId;
  final int groupId;
  final int manageUserId;
  final int addTime;
  final String note;
  final GroupApplicationState state;
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
class GroupApplicationList {
  GroupApplicationList({this.total, this.list});

  factory GroupApplicationList.fromJson(Map<String, dynamic> json) =>
      _$GroupApplicationListFromJson(json);
  Map<String, dynamic> toJson() => _$GroupApplicationListToJson(this);

  final int total;
  final List<GroupApplication> list;
}
