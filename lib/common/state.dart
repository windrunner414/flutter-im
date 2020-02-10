import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';

BehaviorSubject<bool> appInitialized = BehaviorSubject<bool>.seeded(false);
BehaviorSubject<User> ownUserInfo = BehaviorSubject<User>();

const String _OwnUserInfoStorageKey = 'auth.own_user_info';

Future<void> initAppState() async {
  final String json = StorageUtil.get(_OwnUserInfoStorageKey);
  ownUserInfo.value =
      json == null ? null : User.fromJson(await executeJsonDecode(json));
  ownUserInfo.listen((User value) async => await StorageUtil.setString(
      _OwnUserInfoStorageKey,
      value == null ? null : await executeJsonEncode(value)));
}
