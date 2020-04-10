import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_application.dart';
import 'package:wechat/model/group_invitation.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/service/base.dart';

part 'group.chopper.dart';

@ChopperApi(baseUrl: '/User')
abstract class GroupService extends BaseService {
  static GroupService create([ChopperClient client]) => _$GroupService(client);

  @Post(path: '/Group/add')
  Future<Response<ApiResponse<int>>> add({
    @Field() @required String groupName,
    @Field() String groupAvatar,
  });

  @Get(path: '/GroupUser/getMyGroupList')
  Future<Response<ApiResponse<GroupList>>> getJoined({
    @Query() int page,
    @Query() int limit = 999999999,
    @Query() String keyword,
  });

  @Get(path: '/GroupUser/getOne')
  Future<Response<ApiResponse<GroupUser>>> getUserInfo({
    @Query() @required int groupId,
    @Query() @required int userId,
  });

  @Get(path: '/Group/getOne')
  Future<Response<ApiResponse<Group>>> getInfo({
    @Query() @required int groupId,
  });

  @Get(path: '/GroupUser/getGroupUserList')
  Future<Response<ApiResponse<GroupUserList>>> getUserList({
    @Query() @required int groupId,
  });

  @Post(path: '/GroupUser/delete')
  Future<Response<ApiResponse<bool>>> deleteUser({
    @Field() @required int groupId,
    @Field() @required int userId,
  });

  @Post(path: '/Group/delete')
  Future<Response<ApiResponse<bool>>> delete({
    @Field() @required int groupId,
  });

  @Post(path: '/Group/update')
  Future<Response<ApiResponse<Group>>> update({
    @Field() @required int groupId,
    @Field() String groupName,
    @Field() int isSpeakForbidden,
    @Field() String groupAvatar,
  });

  @Post(path: '/GroupUser/update')
  Future<Response<ApiResponse<bool>>> updateUser({
    @Field() @required int groupId,
    @Field() @required int userId,
    @Field() String userGroupName,
  });

  @Post(path: '/GroupUserApply/groupApply')
  Future<Response<ApiResponse<Object>>> applyEnter({
    @Field() @required String code,
    @Field() String note,
  });

  @Get(path: '/GroupUserApply/getFriendApplyList')
  Future<Response<ApiResponse<GroupApplicationList>>> getGroupApplications({
    @Query() int page,
    @Query() int limit,
    @Query() int groupId,
    @Query() int state,
  });

  @Post(path: '/GroupUserApply/verify')
  Future<Response<ApiResponse<Object>>> verifyApplication({
    @Field() @required int groupApplyId,
    @Field() @required int state,
    @Field() String note,
  });

  @Post(path: '/GroupUserApply/inviteEnterGroup')
  Future<Response<ApiResponse<Object>>> inviteFriend({
    @Field() @required int groupId,
    @Field() @required int userId,
    @Field() String note,
  });

  @Get(path: '/GroupUserInvitation/getFriendInvitationList')
  Future<Response<ApiResponse<GroupInvitationList>>> getGroupInvitations({
    @Query() int page,
    @Query() int limit,
    @Query() int groupId,
    @Query() int state,
  });

  @Post(path: '/GroupUserInvitation/groupAgree')
  Future<Response<ApiResponse<Object>>> verifyInvitation({
    @Field() @required int groupApplyId,
    @Field() @required int state,
    @Field() String note,
  });
}
