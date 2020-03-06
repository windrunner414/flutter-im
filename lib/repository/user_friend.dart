import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/user_friend.dart';

class UserFriendRepository extends BaseRepository {
  final UserFriendService _userFriendService = inject();

  Future<FriendList> getAll() async {
    friendList.value = (await _userFriendService.getAll()).body.result;
    return friendList.value;
  }

  Future<Friend> updateRemark({
    @required int userId,
    @required String remark,
  }) async =>
      (await _userFriendService.updateRemark(userId: userId, remark: remark))
          .body
          .result;

  Future<void> updateState({
    @required int userId,
    @required FriendState state,
  }) async =>
      (await (state == FriendState.normal
          ? _userFriendService.cancelBlack(userId: userId)
          : _userFriendService.pullBlack(userId: userId)));

  Future<Friend> getUserInfo({@required int userId}) async =>
      (await _userFriendService.getUserInfo(userId: userId)).body.result;

  Future<void> delete({@required int userId}) async =>
      await _userFriendService.delete(userId: userId);
}
