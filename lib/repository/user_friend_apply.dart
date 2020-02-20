import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/user_friend_apply.dart';

class UserFriendApplyRepository extends BaseRepository {
  final UserFriendApplyService _userFriendApplyService = inject();

  Future<void> addFriend({@required int userId, String note}) async =>
      await _userFriendApplyService.addFriend(userId: userId, note: note);

  Future<FriendApplicationList> getFriendApplicationList(
          {@required int page,
          @required int limit,
          FriendApplicationState state}) async =>
      (await _userFriendApplyService.getFriendApplicationList(
              page: page,
              limit: limit,
              state: state == null
                  ? null
                  : FriendApplication(state: state).toJson()['state'] as int))
          .body
          .result;

  Future<void> verify({
    @required int friendApplyId,
    @required FriendApplicationState state,
    String note,
  }) async =>
      await _userFriendApplyService.verify(
        friendApplyId: friendApplyId,
        state: FriendApplication(state: state).toJson()['state'] as int,
        note: note,
      );
}
