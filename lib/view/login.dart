import 'package:flutter/material.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/route.dart';
import 'package:wechat/widget/login_input.dart';

enum _ActionItems { SERVER_SETTINGS }

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("登录"),
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<_ActionItems>>[
                PopupMenuItem(
                  child: Text(
                    "服务器设置",
                    style: TextStyle(
                        color: const Color(AppColors.AppBarPopupMenuColor)),
                  ),
                  value: _ActionItems.SERVER_SETTINGS,
                ),
              ];
            },
            icon: Icon(
              IconData(0xe66b, fontFamily: Constants.IconFontFamily),
              size: 22.0,
            ),
            onSelected: (_ActionItems selected) {
              switch (selected) {
                case _ActionItems.SERVER_SETTINGS:
                  Router.navigateTo(context, Page.ServerSetting);
                  break;
              }
            },
            tooltip: "菜单",
          ),
          Container(width: 16.0)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 96,
                  height: 96,
                ),
              ),
              SizedBox(height: 40),
              LoginInput(
                label: "用户名",
              ),
              LoginInput(
                label: "密码",
              ),
              SizedBox(height: 30),
              FlatButton(
                onPressed: () {},
                color: Color(AppColors.LoginInputActive),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "登录",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
