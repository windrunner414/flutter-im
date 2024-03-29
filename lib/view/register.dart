import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/register.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/stream_builder.dart';
import 'package:wechat/widget/unfocus_scope.dart';

class RegisterPage extends BaseView<RegisterViewModel> {
  @override
  Widget build(BuildContext context, RegisterViewModel viewModel) {
    dependOnScreenUtil(context);
    return UnFocusScope(
      child: Scaffold(
        appBar: IAppBar(title: const Text('注册')),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 32.width),
          children: <Widget>[
            SizedBox(height: 40.height),
            Center(
              child: UImage(
                'asset://assets/images/logo.png',
                width: 96.height,
                height: 96.height,
              ),
            ),
            SizedBox(height: 40.height),
            LoginInput(
              label: '用户名',
              controller: viewModel.usernameEditingController,
            ),
            LoginInput(
              label: '账号',
              controller: viewModel.accountEditingController,
            ),
            LoginInput(
              label: '密码',
              obscureText: true,
              controller: viewModel.passwordEditingController,
            ),
            LoginInput(
              label: '确认密码',
              obscureText: true,
              controller: viewModel.rePasswordEditingController,
            ),
            Stack(
              children: <Widget>[
                LoginInput(
                  label: '验证码',
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(RegExp(r'[0-9a-zA-Z]')),
                  ],
                  controller: viewModel.verifyCodeEditingController,
                ),
                Positioned(
                  right: 0,
                  bottom: 12.height + 4, // padding.height + contentPadding
                  child: IStreamBuilder<VerifyCode>(
                    stream: viewModel.verifyCode,
                    builder: (BuildContext context,
                        AsyncSnapshot<VerifyCode> snapshot) {
                      Widget buildPlaceholder({bool hasError = false}) =>
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 6.height, right: 16.width),
                            child: Text(
                              hasError ? '加载失败' : '加载中',
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.black87),
                            ),
                          );
                      Widget widget;
                      bool canRefresh = true;
                      if (snapshot.hasData) {
                        try {
                          widget = Image.memory(
                            base64Decode(
                                snapshot.data.verifyCode.split(',')[1]),
                            width: 162.width,
                            height: 50.height,
                            fit: BoxFit.fill,
                          );
                        } catch (error) {
                          widget = buildPlaceholder(hasError: true);
                        }
                      } else {
                        widget = buildPlaceholder(hasError: snapshot.hasError);
                        if (!snapshot.hasError) {
                          canRefresh = false;
                        }
                      }
                      return RepaintBoundary(
                        child: !canRefresh
                            ? widget
                            : GestureDetector(
                                onTap: viewModel.refreshVerifyCode,
                                child: widget,
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.height),
            FlatButton(
              onPressed: () => viewModel.register().then((_) {
                showToast('注册成功');
                router.pop();
              }).catchAll(
                (Object error) {
                  showToast(error.toString());
                },
                test: exceptCancelException,
              ).showLoadingUntilComplete(),
              color: const Color(AppColor.LoginInputActiveColor),
              padding: EdgeInsets.symmetric(vertical: 10.height),
              child: Center(
                child: Text(
                  '注册',
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
