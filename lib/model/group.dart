import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'group.g.dart';

class _IsForbiddenConverter implements JsonConverter<bool, dynamic> {
  const _IsForbiddenConverter();

  bool fromJson(dynamic v) {
    if (v is bool) {
      return v;
    } else if (v is int) {
      return v == 1 ? true : false;
    } else {
      return false;
    }
  }

  int toJson(bool v) => v ? 1 : 0;
}

@JsonSerializable()
@CopyWith()
class Group extends BaseModel {
  Group({
    this.groupUserListId,
    this.groupAvatar,
    this.groupName,
    this.userId,
    this.groupId,
    this.userName,
    int addTime,
    this.state,
    this.isForbidden,
    int lastSpeakTime,
    this.manageUserId,
    this.userGroupName,
  })  : addTime =
            (addTime ?? 99999999999) < 9999999999 ? addTime * 1000 : addTime,
        lastSpeakTime = (lastSpeakTime ?? 99999999999) < 9999999999
            ? lastSpeakTime * 1000
            : lastSpeakTime;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  final int groupUserListId;
  final int groupId;
  final int userId;
  final String userName;
  final String userGroupName;
  final int addTime;
  final int lastSpeakTime;
  @_IsForbiddenConverter()
  final bool isForbidden;
  final int state;
  final String groupName;
  final String groupAvatar;
  final int manageUserId;

  @override
  bool operator ==(dynamic other) {
    if (super == other) {
      return true;
    }
    if (other is Group) {
      return groupUserListId == other.groupUserListId &&
          groupId == other.groupId &&
          userId == other.userId &&
          userName == other.userName &&
          userGroupName == other.userGroupName &&
          addTime == other.addTime &&
          lastSpeakTime == other.lastSpeakTime &&
          isForbidden == other.isForbidden &&
          state == other.state &&
          groupName == other.groupName &&
          groupAvatar == other.groupAvatar &&
          manageUserId == other.manageUserId;
    } else {
      return false;
    }
  }
}

@JsonSerializable()
class GroupList extends BaseModel {
  GroupList({this.list, this.total});

  factory GroupList.fromJson(Map<String, dynamic> json) =>
      _$GroupListFromJson(json);
  Map<String, dynamic> toJson() => _$GroupListToJson(this);

  final List<Group> list;
  final int total;
}
