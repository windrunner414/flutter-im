import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/model/verify_code.dart';
import 'package:wechat/route.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/viewmodel/login.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/viewmodel_provider.dart';

enum _ActionItems { SERVER_SETTINGS }

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = ViewModelProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight.height),
        child: AppBar(
          title: Text("登录"),
          elevation: 0.0,
          actions: <Widget>[
            PopupMenuButton(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<_ActionItems>>[
                PopupMenuItem(
                  child: Text(
                    "服务器设置",
                    style: TextStyle(
                        color: const Color(AppColors.AppBarPopupMenuColor)),
                  ),
                  value: _ActionItems.SERVER_SETTINGS,
                ),
              ],
              icon: Icon(
                IconData(0xe66b, fontFamily: Constants.IconFontFamily),
                size: 22.minWidthHeight,
              ),
              onSelected: (_ActionItems selected) async {
                switch (selected) {
                  case _ActionItems.SERVER_SETTINGS:
                    if (await Router.navigateTo(Page.ServerSetting) == true) {
                      viewModel.refreshVerifyCode();
                    }
                    break;
                }
              },
              tooltip: "菜单",
            ),
            SizedBox(width: 16.width)
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.width),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.height),
            Center(
              child: Image.asset(
                "assets/images/logo.png",
                width: 96.minWidthHeight,
                height: 96.minWidthHeight,
              ),
            ),
            SizedBox(height: 40.height),
            LoginInput(
              label: "用户名",
              defaultText: viewModel.username,
              onChanged: (value) => viewModel.username = value,
            ),
            LoginInput(
              label: "密码",
              obscureText: true,
              defaultText: viewModel.password,
              onChanged: (value) => viewModel.password = value,
            ),
            Stack(
              children: <Widget>[
                LoginInput(
                  label: "验证码",
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp(r"[0-9a-zA-Z]")),
                  ],
                  defaultText: viewModel.verifyCode,
                  onChanged: (value) => viewModel.verifyCode = value,
                ),
                Positioned(
                  right: 0,
                  bottom: 16.height,
                  child: StreamBuilder(
                    stream: viewModel.verifyCodeStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<VerifyCode> snapshot) {
                      Widget widget;
                      if (snapshot.hasData) {
                        widget = Image.memory(
                          base64Decode(snapshot.data.verifyCode.split(",")[1]),
                          width: 162.width,
                          height: 50.height,
                          fit: BoxFit.fill,
                        );
                      } else {
                        widget = Padding(
                          padding: EdgeInsets.only(
                              bottom: 6.height, right: 16.width),
                          child: Text(
                            snapshot.hasError ? "加载失败" : "加载中",
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.black87),
                          ),
                        );
                      }
                      return !snapshot.hasData && !snapshot.hasError
                          ? widget
                          : GestureDetector(
                              onTap: () => viewModel.refreshVerifyCode(),
                              child: widget,
                            );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.height),
            FlatButton(
              onPressed: () {},
              color: Color(AppColors.LoginInputActive),
              padding: EdgeInsets.symmetric(vertical: 10.height),
              child: Center(
                child: Text(
                  "登录",
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
