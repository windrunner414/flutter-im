import 'package:chopper/chopper.dart';
import 'package:wechat/service/interceptors/base.dart';

class ThrowErrorInterceptor extends BaseInterceptor {
  @override
  String get name => 'ThrowError';

  @override
  Response<dynamic> onResponse(Response<dynamic> response) {
    if (!response.isSuccessful) {
      throw response;
    }
    return response;
  }
}
