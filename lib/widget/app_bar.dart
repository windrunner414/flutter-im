import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/util/screen_util.dart';

class IAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget> actions;

  IAppBar({@required this.title, this.actions})
      : preferredSize = Size.fromHeight(56.height);

  @override
  Widget build(BuildContext context) => Theme(
      data: ThemeData.light().copyWith(
        primaryColor: Color(AppColor.AppBarColor),
        cardColor: Color(AppColor.AppBarColor),
      ),
      child: AppBar(
        title: Text(title, style: TextStyle(fontSize: 21.sp)),
        elevation: 0,
        actions: actions,
      ));
}
