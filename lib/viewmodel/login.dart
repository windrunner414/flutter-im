import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/common.dart';
import 'package:wechat/viewmodel/base.dart';

class LoginViewModel extends BaseViewModel {
  final CommonRepository _commonRepository = inject();
  final AuthRepository _authRepository = inject();

  final BehaviorSubject<VerifyCode> verifyCode = BehaviorSubject<VerifyCode>();
  final TextEditingController accountEditingController =
      TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController verifyCodeEditingController =
      TextEditingController();

  Future<void> refreshVerifyCode() async {
    verifyCode.value = null;
    try {
      verifyCode.value = await _commonRepository
          .getVerifyCode()
          .bindTo(this, 'getVerifyCode')
          .wrapError();
    } on CancelException {
      // do nothing
    } catch (error) {
      verifyCode.addError(error);
    }
  }

  Future<void> login() async {
    if (accountEditingController.text.isEmpty) {
      throw const ViewModelException<String>('请填写账号');
    }
    if (passwordEditingController.text.isEmpty) {
      throw const ViewModelException<String>('请填写密码');
    }
    if (verifyCodeEditingController.text.isEmpty) {
      throw const ViewModelException<String>('请填写验证码');
    }
    if (verifyCode.value == null) {
      throw const ViewModelException<String>('未获取验证码');
    }
    await _authRepository
        .login(
          userAccount: accountEditingController.text,
          userPassword: passwordEditingController.text,
          verifyCodeTime: verifyCode.value.verifyCodeTime,
          verifyCodeHash: verifyCode.value.verifyCodeHash,
          verifyCode: verifyCodeEditingController.text,
        )
        .bindTo(this)
        .wrapError();
  }

  @override
  void init() {
    super.init();
    accountEditingController.text = ownUserInfo.value?.userAccount ?? '';
    refreshVerifyCode();
  }

  @override
  void dispose() {
    super.dispose();
    verifyCode.close();
    accountEditingController.dispose();
    passwordEditingController.dispose();
    verifyCodeEditingController.dispose();
  }
}
