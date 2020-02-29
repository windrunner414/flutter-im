import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';

BehaviorSubject<User> ownUserInfo = BehaviorSubject<User>();
BehaviorSubject<FriendList> friendList = BehaviorSubject<FriendList>();
BehaviorSubject<Map<String, User>> cachedUser =
    BehaviorSubject<Map<String, User>>(); // Map<int, User>不能jsonEncode

const String _OwnUserInfoStorageKey = 'auth.own_user_info';
const String _FriendListStorageKey = 'friend_list';
const String _CachedUserStorageKey = 'cached_user';
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

  final String cachedUserJson = StorageUtil.get(_CachedUserStorageKey);
  final cachedValue = <String, User>{};
  if (cachedUserJson != null) {
    final d = await worker.jsonDecode(cachedUserJson) as Map<String, dynamic>;
    for (var v in d.entries) {
      int key = int.tryParse(v.key);
      if (key != null) {
        cachedValue[v.key] = User.fromJson(v.value);
      }
    }
  }
  cachedUser.value = cachedValue;
  friendList.listen((value) {
    final cache = cachedUser.value;
    for (Friend friend in value.list) {
      final String userId = friend.targetUserId.toString();
      var d = cache[userId];
      if (d == null ||
          (d.userName != friend.showName ||
              d.userAvatar != friend.userAvatar)) {
        cache[userId] = User(
          userName: friend.showName,
          userId: friend.targetUserId,
          userAvatar: friend.userAvatar,
        );
      }
    }
    cachedUser.value = cache;
  });
  cachedUser.listen((value) async {
    await StorageUtil.setString(
      _CachedUserStorageKey,
      await worker.jsonEncode(value),
    );
  });
}

User findUserInfoInCache(int id) {
  final String userId = id.toString();
  final info = cachedUser.value[userId];
  if (info != null) {
    return info;
  }
  return null;
}
