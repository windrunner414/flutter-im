import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/util/screen.dart';

class IAppBar extends StatelessWidget implements PreferredSizeWidget {
  IAppBar({Key key, @required this.title, this.actions})
      : preferredSize = Size.fromHeight(56.height),
        super(key: key);

  @override
  final Size preferredSize;

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Theme(
      data: ThemeData.light().copyWith(
        primaryColor: const Color(AppColor.AppBarColor),
        cardColor: const Color(AppColor.AppBarColor),
      ),
      child: AppBar(
        title: Text(title, style: TextStyle(fontSize: 21.sp)),
        elevation: 0,
        actions: actions,
      ));
}
