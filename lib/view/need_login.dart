import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/widget/app_bar.dart';

class NeedLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(title: const Text('需要登录')),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                '请先登录',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FlatButton(
              onPressed: () =>
                  router.pushAndRemoveUntil('/login', (_) => false),
              child: Text(
                '去登录',
                style: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
              color: const Color(AppColor.LoginInputNormalColor),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ],
        ),
      ),
    );
  }
}
