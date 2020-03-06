import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';

final BehaviorSubject<User> ownUserInfo = BehaviorSubject<User>();
final BehaviorSubject<FriendList> friendList = BehaviorSubject<FriendList>();
final BehaviorSubject<GroupList> groupList = BehaviorSubject<GroupList>();

const String _OwnUserInfoStorageKey = 'auth.own_user_info';
const String _FriendListStorageKey = 'friend_list';
const String _GroupListStorageKey = 'group_list';
const int _MaxCachedNoFriendUserNum = 500;

Future<void> initAppState() async {
  final String json = StorageUtil.get(_OwnUserInfoStorageKey);
  ownUserInfo.value =
      json == null ? null : User.fromJson(await worker.jsonDecode(json));
  ownUserInfo.listen((User value) async => await StorageUtil.setString(
      _OwnUserInfoStorageKey,
      value == null ? null : await worker.jsonEncode(value)));

  final String friendListJson = StorageUtil.get(_FriendListStorageKey);
  friendList.value = friendListJson == null
      ? FriendList(total: 0, list: [])
      : FriendList.fromJson(await worker.jsonDecode(friendListJson));
  friendList.listen((value) async {
    await StorageUtil.setString(
        _FriendListStorageKey, await worker.jsonEncode(value));
  });

  final String groupListJson = StorageUtil.get(_GroupListStorageKey);
  groupList.value = groupListJson == null
      ? GroupList(total: 0, list: [])
      : GroupList.fromJson(await worker.jsonDecode(groupListJson));
  groupList.listen((value) async {
    await StorageUtil.setString(
        _GroupListStorageKey, await worker.jsonEncode(value));
  });
}

User findUserInfoInFriendList(int id) {
  final list = friendList.value.list;
  for (Friend friend in list) {
    if (friend.targetUserId == id) {
      return User(
        userId: friend.targetUserId,
        userName: friend.showName,
        userAvatar: friend.userAvatar,
        userAccount: friend.targetUserAccount,
      );
    }
  }
  return null;
}

// TODO:可以做的优化：homeViewModel中不用不断重复拉取好友、群组，拉一次成功了就行了，然后通过好友/创建群等地方来修改friendList/groupList
// TODO:同时friendList和groupList可以转换为id对应的map来高效查找
Group findGroupInfoInJoinedGroup(int id) {
  final list = groupList.value.list;
  for (Group group in list) {
    if (group.groupId == id) {
      return group;
    }
  }
  return null;
}
