import 'package:chopper/chopper.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/interceptors/base.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/layer.dart';

class AuthInterceptor extends BaseInterceptor {
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
      showToast((response.error as ApiResponse<dynamic>).msg ?? '登陆已过期，请重新登录');
      ownUserInfo.value = ownUserInfo.value.copyWith(userSession: '');
    }
    return response;
  }
}
