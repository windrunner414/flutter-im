import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class BaseInterceptor
    implements RequestInterceptor, ResponseInterceptor {
  String get name;
  Set<String> get after => <String>{};
  Set<String> get before => <String>{};

  @override
  FutureOr<Request> onRequest(Request request) {
    return request;
  }

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) {
    return response;
  }
}

class WebClientInterceptors {
  const WebClientInterceptors(this.interceptors);

  final Set<BaseInterceptor> interceptors;

  bool checkValid() {
    final Set<String> names = <String>{};
    for (BaseInterceptor interceptor in interceptors) {
      for (String name in interceptor.before) {
        if (names.contains(name)) {
          return false;
        }
      }
      for (String name in interceptor.after) {
        if (!names.contains(name)) {
          return false;
        }
      }
      if (!names.add(interceptor.name)) {
        return false;
      }
    }
    return true;
  }
}
