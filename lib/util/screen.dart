import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as flutter_screen_util;

bool get _ready => flutter_screen_util.ScreenUtil.mediaQueryData != null;

void initScreenUtil({
  @required double width,
  @required double height,
  bool allowFontScaling = false,
  @required BuildContext context,
}) =>
    flutter_screen_util.ScreenUtil.instance = flutter_screen_util.ScreenUtil(
      width: width,
      height: height,
      allowFontScaling: allowFontScaling,
    )..init(context);

extension ScreenUtilExtension on num {
  double get width => _ready
      ? flutter_screen_util.ScreenUtil.getInstance().setWidth(this).toDouble()
      : toDouble();
  double get height => _ready
      ? flutter_screen_util.ScreenUtil.getInstance().setHeight(this).toDouble()
      : toDouble();
  double get sp => _ready
      ? flutter_screen_util.ScreenUtil.getInstance().setSp(this).toDouble()
      : toDouble();
  double get minWidthHeight => min(width, height);
  double get maxWidthHeight => max(width, height);
}
