import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/friend_apply.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/user_friend_apply.dart';

class UserFriendApplyRepository extends BaseRepository {
  final UserFriendApplyService _userFriendApplyService = inject();

  Future<void> addFriend({@required int userId}) async =>
      await _userFriendApplyService.addFriend(userId: userId);

  Future<FriendApplyList> getFriendApplyList(
          {@required int page,
          @required int limit,
          @required FriendApplyState state}) async =>
      (await _userFriendApplyService.getFriendApplyList(
              page: page,
              limit: limit,
              state: FriendApply(state: state).toJson()['state'] as int))
          .body
          .result;
}
