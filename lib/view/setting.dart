import 'package:flutter/material.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/setting.dart';
import 'package:wechat/widget/app_bar.dart';

class SettingPage extends BaseView<SettingViewModel> {
  @override
  Widget build(BuildContext context, SettingViewModel viewModel) => Scaffold(
        appBar: IAppBar(title: '设置'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.width),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.height),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 96.minWidthHeight,
                  height: 96.minWidthHeight,
                ),
              ),
              SizedBox(height: 40.height),
              FlatButton(
                onPressed: () => viewModel.logout(),
                color: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10.height),
                child: Center(
                  child: Text(
                    '退出登录',
                    style: TextStyle(fontSize: 20.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
