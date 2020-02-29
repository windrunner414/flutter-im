import 'package:chopper/chopper.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';

part 'user_friend.chopper.dart';

@ChopperApi(baseUrl: '/User/UserFriend')
abstract class UserFriendService extends BaseService {
  static UserFriendService create([ChopperClient client]) =>
      _$UserFriendService(client);

  @Get(path: '/getAll')
  Future<Response<ApiResponse<FriendList>>> getAll();
}
