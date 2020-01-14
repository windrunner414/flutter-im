import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/route.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/server_setting.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/unfocus_scope.dart';

class ServerSettingPage extends BaseView<ServerSettingViewModel> {
  @override
  Widget build(BuildContext context, ServerSettingViewModel viewModel) =>
      UnFocusScope(
        child: Scaffold(
          appBar: IAppBar(title: const Text('服务器设置')),
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
                label: '静态文件服务器域名',
                controller: viewModel.staticFileDomainEditingController,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter(RegExp(r'[a-zA-Z0-9\.-]')),
                ],
                keyboardType: TextInputType.url,
              ),
              LoginInput(
                label: '服务器域名',
                controller: viewModel.domainEditingController,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter(RegExp(r'[a-zA-Z0-9\.-]')),
                ],
                keyboardType: TextInputType.url,
              ),
              LoginInput(
                label: 'http端口',
                controller: viewModel.httpPortEditingController,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
              LoginInput(
                label: 'websocket端口',
                controller: viewModel.webSocketPortEditingController,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8.height),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '启用ssl',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  CupertinoSwitch(
                    value: viewModel.useSsl,
                    onChanged: (bool open) {
                      viewModel.useSsl = open;
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.height),
              FlatButton(
                onPressed: () {
                  try {
                    viewModel.save();
                    router.pop(true);
                  } catch (error) {
                    showToast(error.toString());
                  }
                },
                color: const Color(AppColor.LoginInputActiveColor),
                padding: EdgeInsets.symmetric(vertical: 10.height),
                child: Center(
                  child: Text(
                    '保存',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
