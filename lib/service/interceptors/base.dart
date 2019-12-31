import 'package:chopper/chopper.dart';

abstract class BaseInterceptor
    implements RequestInterceptor, ResponseInterceptor {
  @override
  Request onRequest(Request request) {
    return request;
  }

  @override
  Response<dynamic> onResponse(Response<dynamic> response) {
    return response;
  }
}
