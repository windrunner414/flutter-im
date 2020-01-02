import 'package:dartin/dartin.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/auth.dart';
import 'package:wechat/state.dart';

class AuthRepository extends BaseRepository {
  final AuthService _authService = inject();

  Future<User> login(
      {String userAccount,
      String userPassword,
      String verifyCodeHash,
      int verifyCodeTime,
      String verifyCode}) async {
    final User info = (await _authService.login(
            userAccount: userAccount,
            userPassword: userPassword,
            verifyCode: verifyCode,
            verifyCodeHash: verifyCodeHash,
            verifyCodeTime: verifyCodeTime))
        .body
        .result;
    ownUserInfo.value = info;
    return info;
  }

  Future<User> getSelfInfo() async {
    final User info = (await _authService.getSelfInfo())
        .body
        .result
        .copyWith(userSession: ownUserInfo.value.userSession);
    ownUserInfo.value = info;
    return info;
  }
}
