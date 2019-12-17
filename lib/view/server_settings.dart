import 'package:flutter/material.dart';
import 'package:wechat/api.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/widget/login_input.dart';

class ServerSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("服务器设置"),
        elevation: 0.0,
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
                label: "服务器域名",
                defaultText: Api.domain,
              ),
              LoginInput(
                label: "http端口",
                defaultText: Api.httpPort,
              ),
              LoginInput(
                label: "websocket端口",
                defaultText: Api.websocketPort,
              ),
              LoginInput(
                label: "是否ssl",
                defaultText: Api.isSsl ? "1" : "0",
              ),
              SizedBox(height: 30),
              FlatButton(
                onPressed: () {},
                color: Color(AppColors.LoginInputActive),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "保存",
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
