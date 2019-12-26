import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker.dart';

abstract class AppState {
  static BehaviorSubject<User> ownUserInfo = BehaviorSubject();

  static const String _OwnUserInfoStorageKey = "auth.own_user_info";

  static Future<void> init() async {
    String json = StorageUtil.get(_OwnUserInfoStorageKey);
    ownUserInfo.value =
        json == null ? null : User.fromJson(await WorkerUtil.jsonDecode(json));
    ownUserInfo.listen((User value) async => StorageUtil.setString(
        _OwnUserInfoStorageKey,
        value == null ? null : await WorkerUtil.jsonEncode(value)));
  }
}
