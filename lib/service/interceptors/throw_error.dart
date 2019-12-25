import 'package:chopper/chopper.dart';

/// 务必在AuthInterceptor后执行
class ThrowErrorInterceptor implements ResponseInterceptor {
  Response onResponse(Response response) {
    if (!response.isSuccessful) {
      throw response;
    }
    return response;
  }
}
