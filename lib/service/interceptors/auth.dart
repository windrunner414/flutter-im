import 'package:chopper/chopper.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/layer.dart';

class AuthInterceptor implements RequestInterceptor, ResponseInterceptor {
  Request onRequest(Request request) {
    String userSession = AppState.ownUserInfo.value?.userSession ?? "";
    Map<String, dynamic> parameters = Map.from(request.parameters);
    parameters["userSession"] = userSession;
    return request.replace(parameters: parameters);
  }

  Response onResponse(Response response) {
    if (response.statusCode == 401) {
      LayerUtil.showToast((response.error as ApiResponse).msg ?? "登陆已过期，请重新登录");
      AppState.ownUserInfo.value =
          AppState.ownUserInfo.value.copyWith(userSession: null);
    }
    return response;
  }
}
