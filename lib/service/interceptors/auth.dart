import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/service/interceptors/base.dart';
import 'package:wechat/util/layer.dart';

class AuthInterceptor extends BaseInterceptor {
  @override
  String get name => 'Auth';

  @override
  Set<String> get before => <String>{'throw_error'};

  @override
  Request onRequest(Request request) {
    final String userSession = ownUserInfo.value?.userSession ?? '';
    final Map<String, dynamic> parameters =
        Map<String, dynamic>.from(request.parameters);
    parameters['userSession'] = userSession;
    return request.replace(parameters: parameters);
  }

  @override
  Response<dynamic> onResponse(Response<dynamic> response) {
    if (response.statusCode == 401) {
      ownUserInfo.value = ownUserInfo.value.copyWith(userSession: '');
      Timer.run(() => showToast(
          (response.error as ApiResponse<dynamic>).msg ?? '登陆已过期，请重新登录'));
    }
    return response;
  }

  @override
  WebSocketMessage<dynamic> onReceive(WebSocketMessage<dynamic> message) {
    if (const <int>{-1002, -1003}.contains(message.op)) {
      ownUserInfo.value = ownUserInfo.value.copyWith(userSession: '');
      Timer.run(() => showToast(message.msg ?? '登陆已过期，请重新登录'));
    }
    return message;
  }
}
