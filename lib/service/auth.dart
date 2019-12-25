import 'package:chopper/chopper.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';

part 'auth.chopper.dart';

@ChopperApi(baseUrl: "/User/Auth")
abstract class AuthService extends BaseService {
  static AuthService create([ChopperClient client]) => _$AuthService(client);

  @Get(path: "/getInfo")
  Future<Response<ApiResponse<User>>> getSelfInfo();
}
