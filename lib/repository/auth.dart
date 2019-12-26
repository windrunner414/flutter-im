import 'package:dartin/dartin.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/auth.dart';
import 'package:wechat/state.dart';

class AuthRepository extends BaseRepository {
  AuthService _authService = inject();

  Future<User> login(
      {String userAccount,
      String userPassword,
      String verifyCodeHash,
      int verifyCodeTime,
      String verifyCode}) async {
    User info = (await _authService.login(
            userAccount: userAccount,
            userPassword: userPassword,
            verifyCode: verifyCode,
            verifyCodeHash: verifyCodeHash,
            verifyCodeTime: verifyCodeTime))
        .body
        .result;
    AppState.ownUserInfo.value = info;
    return info;
  }

  Future<User> getSelfInfo() async {
    User info = (await _authService.getSelfInfo())
        .body
        .result
        .copyWith(userSession: AppState.ownUserInfo.value.userSession);
    AppState.ownUserInfo.value = info;
    return info;
  }
}
