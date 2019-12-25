import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/repository/common.dart';
import 'package:wechat/viewmodel/base.dart';

class LoginViewModel extends BaseViewModel {
  final CommonRepository _commonRepository = inject();

  final BehaviorSubject<VerifyCode> verifyCode = BehaviorSubject();
  final TextEditingController usernameEditingController =
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
    }
  }

  @override
  void init() {
    super.init();
    usernameEditingController.text = ""; // TODO:保存用户名
    refreshVerifyCode();
  }

  @override
  void dispose() {
    super.dispose();
    verifyCode.close();
  }
}
