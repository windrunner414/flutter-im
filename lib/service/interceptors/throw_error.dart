import 'package:chopper/chopper.dart';
import 'package:wechat/service/interceptors/base.dart';

/// 务必在AuthInterceptor后执行
class ThrowErrorInterceptor extends BaseInterceptor {
  @override
  Response<dynamic> onResponse(Response<dynamic> response) {
    if (!response.isSuccessful) {
      throw response;
    }
    return response;
  }
}
