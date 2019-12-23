import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/route.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/viewmodel/server_setting.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/viewmodel_provider.dart';

class ServerSettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServerSettingViewModel viewModel = ViewModelProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight.height),
          child: AppBar(
            title: Text("服务器设置"),
            elevation: 0.0,
          )),
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
              label: "服务器域名",
              defaultText: viewModel.config.domain,
              onChanged: (String value) => viewModel.config.domain = value,
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z0-9\.-]")),
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
              onChanged: (String value) =>
                  viewModel.config.webSocketPort = int.tryParse(value) ?? 9701,
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
                  value: viewModel.config.ssl,
                  onChanged: (open) {
                    viewModel.config.ssl = open;
                  },
                ),
              ],
            ),
            SizedBox(height: 30.height),
            FlatButton(
              onPressed: () {
                viewModel.save();
                LayerUtil.showToast("保存成功");
                Router.pop(true);
              },
              color: Color(AppColors.LoginInputActive),
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
}
