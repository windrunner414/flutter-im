import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wechat/model/base.dart';

part 'group_user.g.dart';

enum GroupUserState {
  @JsonValue(1)
  normal,
  @JsonValue(2)
  disable,
}

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
class GroupUser extends BaseModel {
  GroupUser({
    this.groupUserListId,
    this.groupId,
    this.userId,
    this.userName,
    this.userGroupName,
    int addTime,
    int lastSpeakTime,
    this.isForbidden,
    this.state,
    this.userAvatar,
    this.userAccount,
  })  : addTime =
            (addTime ?? 99999999999) < 9999999999 ? addTime * 1000 : addTime,
        lastSpeakTime = (lastSpeakTime ?? 99999999999) < 9999999999
            ? lastSpeakTime * 1000
            : lastSpeakTime;

  factory GroupUser.fromJson(Map<String, dynamic> json) =>
      _$GroupUserFromJson(json);
  Map<String, dynamic> toJson() => _$GroupUserToJson(this);

  final int groupUserListId;
  final int groupId;
  final int userId;
  final String userName;
  final String userGroupName;
  final int addTime;
  final int lastSpeakTime;
  @_IsForbiddenConverter()
  final bool isForbidden;
  final GroupUserState state;
  final String userAvatar;
  @JsonKey(name: 'userAvatarAccount') // TODO: ???
  final String userAccount;
  String get showName => userGroupName ?? userName;

  @override
  bool operator ==(dynamic other) {
    if (super == other) {
      return true;
    }
    if (other is GroupUser) {
      return groupUserListId == other.groupUserListId &&
          groupId == other.groupId &&
          userId == other.userId &&
          userName == other.userName &&
          userGroupName == other.userGroupName &&
          addTime == other.addTime &&
          lastSpeakTime == other.lastSpeakTime &&
          isForbidden == other.isForbidden &&
          state == other.state &&
          userAvatar == other.userAvatar &&
          userAccount == other.userAccount;
    } else {
      return false;
    }
  }
}

@JsonSerializable()
class GroupUserList extends BaseModel {
  GroupUserList({this.total, this.list});

  factory GroupUserList.fromJson(Map<String, dynamic> json) =>
      _$GroupUserListFromJson(json);
  Map<String, dynamic> toJson() => _$GroupUserListToJson(this);

  final int total;
  final List<GroupUser> list;
}
