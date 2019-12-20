import '../api.dart';
import 'base.dart';

class LoginViewModel extends BaseViewModel {
  @override
  void init() {
    /*httpApiClient
        .getVerifyCode()
        .then((v) => print(v.toJson()), onError: (e) => print(e));*/
    httpApiClient.getUserInfo();
  }

  @override
  void dispose() {}
}
