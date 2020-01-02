import 'package:chopper/chopper.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/service/base.dart';

part 'common.chopper.dart';

@ChopperApi(baseUrl: '/Common')
abstract class CommonService extends BaseService {
  static CommonService create([ChopperClient client]) =>
      _$CommonService(client);

  @Get(path: '/VerifyCode/verifyCode')
  Future<Response<ApiResponse<VerifyCode>>> getVerifyCode();
}
