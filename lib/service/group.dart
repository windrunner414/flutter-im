import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/group.dart';
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
}
