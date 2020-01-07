import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/base.dart';

class ErrorPage extends BaseView<BaseViewModel> {
  ErrorPage({this.errorDetail});

  final String errorDetail;

  @override
  Widget build(BuildContext context, BaseViewModel viewModel) => Container(
        padding: EdgeInsets.symmetric(horizontal: 32.width),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: 70.height),
            Text(
              '啊哦，崩溃了',
              style: TextStyle(
                fontSize: 24.sp,
                decoration: TextDecoration.none,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 50.height),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  errorDetail,
                  style: TextStyle(
                    fontSize: 16.sp,
                    decoration: TextDecoration.none,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.height),
          ],
        ),
      );
}
