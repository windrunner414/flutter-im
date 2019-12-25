import 'package:chopper/chopper.dart';
import 'package:wechat/service/base.dart';

part 'user.chopper.dart';

@ChopperApi()
abstract class UserService extends BaseService {
  static UserService create([ChopperClient client]) => _$UserService(client);

  //@Get()
  //Future<Response<ApiResponse<User>>>
}
