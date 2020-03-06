import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/group.dart';

class GroupRepository extends BaseRepository {
  final GroupService _groupService = inject();

  Future<int> create({@required String groupName, String groupAvatar}) async =>
      (await _groupService.add(groupName: groupName, groupAvatar: groupAvatar))
          .body
          .result;

  Future<GroupList> getJoined() async {
    groupList.value = (await _groupService.getJoined()).body.result;
    return groupList.value;
  }

  Future<GroupUser> getUserInfo({
    @required int userId,
    @required int groupId,
  }) async =>
      (await _groupService.getUserInfo(userId: userId, groupId: groupId))
          .body
          .result;
}
