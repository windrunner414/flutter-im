import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_application.dart';
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
    joinedGroupList.value = (await _groupService.getJoined()).body.result;
    return joinedGroupList.value;
  }

  Future<GroupUser> getUserInfo({
    @required int userId,
    @required int groupId,
  }) async =>
      (await _groupService.getUserInfo(userId: userId, groupId: groupId))
          .body
          .result;

  Future<Group> getInfo({@required int groupId}) async =>
      (await _groupService.getInfo(groupId: groupId)).body.result;

  Future<GroupUserList> getUserList({@required int groupId}) async =>
      (await _groupService.getUserList(groupId: groupId)).body.result;

  Future<void> deleteUser({
    @required int userId,
    @required int groupId,
  }) async =>
      await _groupService.deleteUser(groupId: groupId, userId: userId);

  Future<void> delete({@required int groupId}) async =>
      await _groupService.delete(groupId: groupId);

  Future<void> update(
          {@required int groupId,
          String groupName,
          bool isSpeakForbidden,
          String groupAvatar}) async =>
      await _groupService.update(
        groupId: groupId,
        groupAvatar: groupAvatar,
        groupName: groupName,
        isSpeakForbidden:
            isSpeakForbidden == null ? null : (isSpeakForbidden ? 1 : 0),
      );

  Future<void> updateUser({
    @required int userId,
    @required int groupId,
    String userGroupName,
  }) async =>
      await _groupService.updateUser(
        groupId: groupId,
        userId: userId,
        userGroupName: userGroupName,
      );

  Future<void> applyEnter({@required String code}) async =>
      await _groupService.applyEnter(code: code);

  Future<GroupApplicationList> getGroupApplications({
    int page,
    int limit,
    int groupId,
    GroupApplicationState state,
  }) async =>
      (await _groupService.getGroupApplications(
        page: page,
        limit: limit,
        groupId: groupId,
        state: GroupApplication(state: state).toJson()['state'],
      ))
          .body
          .result;

  Future<void> verifyApplication({
    @required int groupApplyId,
    @required GroupApplicationState state,
    String note,
  }) async =>
      (await _groupService.verifyApplication(
        groupApplyId: groupApplyId,
        state: GroupApplication(state: state).toJson()['state'],
        note: note,
      ))
          .body
          .result;
}
