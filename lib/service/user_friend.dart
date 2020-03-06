import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/service/base.dart';

part 'user_friend.chopper.dart';

@ChopperApi(baseUrl: '/User/UserFriend')
abstract class UserFriendService extends BaseService {
  static UserFriendService create([ChopperClient client]) =>
      _$UserFriendService(client);

  @Get(path: '/getAll')
  Future<Response<ApiResponse<FriendList>>> getAll({
    @Query() int page,
    @Query() int limit = 999999999,
    @Query() String keyword,
  });

  @Get(path: '/getOne')
  Future<Response<ApiResponse<Friend>>> getUserInfo({
    @Query() @required int userId,
  });

  @Post(path: '/remarkUpdate')
  Future<Response<ApiResponse<Friend>>> updateRemark({
    @Field() @required int userId,
    @Field() @required String remark,
  });

  @Post(path: '/pullBlack')
  Future<Response<ApiResponse<void>>> pullBlack({
    @Field() @required int userId,
  });

  @Post(path: '/cancelBlack')
  Future<Response<ApiResponse<void>>> cancelBlack({
    @Field() @required int userId,
  });

  @Post(path: '/delete')
  Future<Response<ApiResponse<dynamic>>> delete({
    @Field() @required int userId,
  });
}
