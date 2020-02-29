import 'dart:math';

import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/util/screen.dart';

class IAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IAppBar({
    Key key,
    this.leading,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(max(38.height, 38));
  final Widget leading;
  final Widget title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return Theme(
      data: ThemeData(
        primaryColor: const Color(AppColor.AppBarColor),
        cardColor: const Color(AppColor.AppBarColor),
      ),
      child: AppBar(
        leading: leading,
        title: title == null
            ? null
            : DefaultTextStyle(
                style: TextStyle(fontSize: 19.height, color: Colors.white),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                child: title,
              ),
        elevation: 0,
        actions: actions,
      ),
    );
  }
}
