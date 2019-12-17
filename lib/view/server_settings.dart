import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/widget/login_input.dart';

import '../viewmodel/provider.dart';
import '../viewmodel/server_settings.dart';

class ServerSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServerSettingsViewModel viewModel = ViewModelProvider.of(context);
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
                defaultText: viewModel.settings.domain,
                onChanged: (String value) => viewModel.settings.domain = value,
              ),
              LoginInput(
                label: "http端口",
                defaultText: viewModel.settings.httpPort.toString(),
                onChanged: (String value) =>
                    viewModel.settings.httpPort = int.tryParse(value) ?? 80,
              ),
              LoginInput(
                label: "websocket端口",
                defaultText: viewModel.settings.webSocketPort.toString(),
                onChanged: (String value) => viewModel.settings.webSocketPort =
                    int.tryParse(value) ?? 9701,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "启用ssl",
                    style: TextStyle(fontSize: 18),
                  ),
                  CupertinoSwitch(
                    value: viewModel.settings.ssl,
                    onChanged: (open) {
                      viewModel.settings.ssl = open;
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              FlatButton(
                onPressed: () => viewModel.save(),
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
