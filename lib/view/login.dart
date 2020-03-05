import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/stream_builder.dart';
import 'package:wechat/widget/unfocus_scope.dart';

enum _PopupMenuItems { serverSetting }

class LoginPage extends BaseView<LoginViewModel> {
  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    dependOnScreenUtil(context);
    return UnFocusScope(
      child: Scaffold(
        appBar: IAppBar(
          title: const Text('登录'),
          actions: <Widget>[
            PopupMenuButton<_PopupMenuItems>(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<_PopupMenuItems>>[
                PopupMenuItem<_PopupMenuItems>(
                  child: Builder(
                    builder: (BuildContext context) {
                      dependOnScreenUtil(context);
                      return Text(
                        '服务器设置',
                        style: TextStyle(
                          color: const Color(AppColor.AppBarPopupMenuColor),
                          fontSize: 16.sp,
                        ),
                      );
                    },
                  ),
                  value: _PopupMenuItems.serverSetting,
                ),
              ],
              icon: Icon(
                const IconData(0xe66b, fontFamily: Constant.IconFontFamily),
                size: 19.sp,
              ),
              onSelected: (_PopupMenuItems selected) async {
                switch (selected) {
                  case _PopupMenuItems.serverSetting:
                    if (await router.push<bool>('/serverSetting') == true) {
                      viewModel.refreshVerifyCode();
                    }
                    break;
                }
              },
              tooltip: '菜单',
            ),
            const SizedBox(width: 16)
          ],
        ),
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
              label: '账号',
              controller: viewModel.accountEditingController,
            ),
            LoginInput(
              label: '密码',
              obscureText: true,
              controller: viewModel.passwordEditingController,
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
              onPressed: () => viewModel.login().catchAll(
                (Object error) {
                  showToast(error.toString());
                },
                test: exceptCancelException,
              ).showLoadingUntilComplete(),
              color: const Color(AppColor.LoginInputActiveColor),
              padding: EdgeInsets.symmetric(vertical: 10.height),
              child: Center(
                child: Text(
                  '登录',
                  style: TextStyle(fontSize: 20.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 15.height),
            Center(
              child: GestureDetector(
                onTap: () => router.push('/register'),
                child: Text(
                  '没有账号？点此注册',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(AppColor.LoginInputNormalColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
