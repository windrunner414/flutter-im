import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/util/screen.dart';

class IAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ignore: prefer_const_constructors_in_immutables, 屏幕大小改变时需要rebuild，若为const不会rebuild
  IAppBar({Key key, @required this.title, this.actions}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(46.height);

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Theme(
      data: ThemeData.light().copyWith(
        primaryColor: const Color(AppColor.AppBarColor),
        cardColor: const Color(AppColor.AppBarColor),
      ),
      child: AppBar(
        title: Text(title, style: TextStyle(fontSize: 19.sp)),
        elevation: 0,
        actions: actions,
      ));
}
