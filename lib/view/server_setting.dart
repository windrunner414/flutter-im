import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import '../route.dart';
import '../util/toast.dart';
import '../viewmodel/provider.dart';
import '../viewmodel/server_setting.dart';
import '../widget/login_input.dart';

class ServerSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServerSettingViewModel viewModel = ViewModelProvider.of(context);
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
                defaultText: viewModel.config.domain,
                onChanged: (String value) => viewModel.config.domain = value,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9\\.-]")),
                ],
                keyboardType: TextInputType.url,
              ),
              LoginInput(
                label: "http端口",
                defaultText: viewModel.config.httpPort.toString(),
                onChanged: (String value) =>
                    viewModel.config.httpPort = int.tryParse(value) ?? 80,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
              LoginInput(
                label: "websocket端口",
                defaultText: viewModel.config.webSocketPort.toString(),
                onChanged: (String value) => viewModel.config.webSocketPort =
                    int.tryParse(value) ?? 9701,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
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
                    value: viewModel.config.ssl,
                    onChanged: (open) {
                      viewModel.config.ssl = open;
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),
              FlatButton(
                onPressed: () {
                  viewModel.save();
                  ToastUtil.show("保存成功");
                  Router.pop(context);
                },
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
