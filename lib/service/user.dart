import 'package:chopper/chopper.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';

part 'user.chopper.dart';

@ChopperApi(baseUrl: '/User/User')
abstract class UserService extends BaseService {
  static UserService create([ChopperClient client]) => _$UserService(client);

  @Get(path: '/getAll')
  Future<Response<ApiResponse<UserList>>> search({
    @Query() @required String keyword,
    @Query() @required int page,
    @Query() @required int limit,
  });
}
