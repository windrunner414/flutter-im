import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/auth.dart';

class AuthRepository extends BaseRepository {
  final AuthService _authService = inject();

  Future<User> login(
      {@required String userAccount,
      @required String userPassword,
      @required String verifyCodeHash,
      @required int verifyCodeTime,
      @required String verifyCode}) async {
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

  Future<void> register(
          {@required String userAccount,
          @required String userName,
          @required String userPassword,
          @required String verifyCodeHash,
          @required int verifyCodeTime,
          @required String verifyCode}) async =>
      await _authService.register(
        userAccount: userAccount,
        userName: userName,
        userPassword: userPassword,
        rePassword: userPassword,
        verifyCode: verifyCode,
        verifyCodeHash: verifyCodeHash,
        verifyCodeTime: verifyCodeTime,
      );

  Future<User> getSelfInfo() async {
    final User info = (await _authService.getSelfInfo())
        .body
        .result
        .copyWith(userSession: ownUserInfo.value.userSession);
    ownUserInfo.value = info;
    return info;
  }
}
