import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/repository/user_friend.dart';
import 'package:wechat/viewmodel/base.dart';

class UserViewModel extends BaseViewModel {
  UserViewModel({this.userId, this.groupId});

  final int userId;
  final int groupId;
  final GroupRepository _groupRepository = inject();
  final UserFriendRepository _userFriendRepository = inject();

  final BehaviorSubject<GroupUser> groupUserData = BehaviorSubject();
  final BehaviorSubject<Friend> friendData = BehaviorSubject();

  @override
  void dispose() {
    super.dispose();
    groupUserData.close();
    friendData.close();
  }

  Future<void> getInfo() async {
    if (groupId != null) {
      groupUserData.value = await _groupRepository
          .getUserInfo(userId: userId, groupId: groupId)
          .bindTo(this, 'getGroupUserData')
          .wrapError();
    }
    if (userId == ownUserInfo.value.userId) {
      friendData.value = Friend(
        friendId: 0,
        targetUserName: ownUserInfo.value.userName,
        userAvatar: ownUserInfo.value.userAvatar,
        addTime: 0,
        state: FriendState.normal,
        targetUserAccount: ownUserInfo.value.userAccount,
        remark: '',
        targetUserId: userId,
      );
    } else {
      try {
        friendData.value = await _userFriendRepository
            .getUserInfo(userId: userId)
            .bindTo(this, 'getFriendData')
            .wrapError();
      } catch (_) {
        if (groupId == null) {
          rethrow;
        }
      }
    }
  }

  Future<void> updateFriendRemark(String remark) async {
    friendData.value = await _userFriendRepository
        .updateRemark(
          userId: userId,
          remark: remark,
        )
        .bindTo(this, 'updateRemark')
        .wrapError();
  }

  Future<void> updateFriendState(FriendState state) async {
    try {
      await _userFriendRepository
          .updateState(userId: userId, state: state)
          .bindTo(this, 'updateFriendStatus')
          .wrapError();
      friendData.value = friendData.value.copyWith(state: state);
    } on CancelException {
      // n
    } catch (_) {
      friendData.value = friendData.value;
      rethrow;
    }
  }

  Future<void> deleteFriend() async {
    await _userFriendRepository
        .delete(userId: userId)
        .bindTo(this, 'deleteFriend')
        .wrapError();
    if (groupId != null) {
      friendData.value = null;
    }
  }
}
