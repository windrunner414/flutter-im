import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat/util/screen.dart';

class ErrorPage extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables, 屏幕大小改变时需要rebuild，若为const不会rebuild
  ErrorPage({this.errorDetail});

  final String errorDetail;

  @override
  Widget build(BuildContext context) => Container(
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
