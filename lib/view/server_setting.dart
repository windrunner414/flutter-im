import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/route.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/server_setting.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/login_input.dart';

class ServerSettingPage extends BaseView<ServerSettingViewModel> {
  @override
  Widget build(BuildContext context, ServerSettingViewModel viewModel) =>
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: IAppBar(title: "服务器设置"),
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
                label: "静态文件服务器域名",
                controller: viewModel.staticFileDomainEditingController,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z0-9\.-]")),
                ],
                keyboardType: TextInputType.url,
              ),
              LoginInput(
                label: "服务器域名",
                controller: viewModel.domainEditingController,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z0-9\.-]")),
                ],
                keyboardType: TextInputType.url,
              ),
              LoginInput(
                label: "http端口",
                controller: viewModel.httpPortEditingController,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
              LoginInput(
                label: "websocket端口",
                controller: viewModel.webSocketPortEditingController,
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
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  CupertinoSwitch(
                    value: viewModel.useSsl,
                    onChanged: (open) {
                      viewModel.useSsl = open;
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.height),
              FlatButton(
                onPressed: () => viewModel.save() ? Router.pop(true) : null,
                color: Color(AppColor.LoginInputActive),
                padding: EdgeInsets.symmetric(vertical: 10.height),
                child: Center(
                  child: Text(
                    "保存",
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
