import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/service/base.dart';

part 'user_friend_apply.chopper.dart';

@ChopperApi(baseUrl: '/User/UserFriendApply')
abstract class UserFriendApplyService extends BaseService {
  static UserFriendApplyService create([ChopperClient client]) =>
      _$UserFriendApplyService(client);

  @Post(path: '/addFriend')
  Future<Response<ApiResponse<dynamic>>> addFriend(
      {@Field() @required int userId});
}