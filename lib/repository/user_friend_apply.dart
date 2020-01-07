import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/user_friend_apply.dart';

class UserFriendApplyRepository extends BaseRepository {
  final UserFriendApplyService _userFriendApplyService = inject();

  Future<void> addFriend({@required int userId}) async =>
      await _userFriendApplyService.addFriend(userId: userId);
}
