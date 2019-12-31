import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/common.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/layer.dart';
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
      verifyCode.value =
          await manageFuture(_commonRepository.getVerifyCode(), #getVerifyCode);
    } on CancelException {} catch (error) {
      verifyCode.addError(error);
      print(error.toString());
    }
  }

  Future<void> login() async {
    if (accountEditingController.text.isEmpty) {
      LayerUtil.showToast('请填写账号');
      return;
    }
    if (passwordEditingController.text.isEmpty) {
      LayerUtil.showToast('请填写密码');
      return;
    }
    if (verifyCodeEditingController.text.isEmpty) {
      LayerUtil.showToast('请填写验证码');
      return;
    }
    if (verifyCode.value == null) {
      LayerUtil.showToast('验证码错误');
      return;
    }
    final UniqueKey loadingKey = LayerUtil.showLoading();
    try {
      await _authRepository.login(
          userAccount: accountEditingController.text,
          userPassword: passwordEditingController.text,
          verifyCodeTime: verifyCode.value.verifyCodeTime,
          verifyCodeHash: verifyCode.value.verifyCodeHash,
          verifyCode: verifyCodeEditingController.text);
    } on CancelException {} catch (error) {
      if (error is Response && error.error is ApiResponse) {
        LayerUtil.showToast((error.error as ApiResponse<dynamic>).msg);
      } else {
        LayerUtil.showToast('网络错误');
        print(error.toString());
      }
    }
    LayerUtil.closeLoading(loadingKey);
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
  }
}
