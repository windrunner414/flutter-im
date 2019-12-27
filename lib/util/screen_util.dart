import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

abstract class ScreenUtil {
  static bool get ready => FlutterScreenUtil.ScreenUtil.mediaQueryData != null;

  static init(
          {@required double width,
          @required double height,
          bool allowFontScaling = false,
          @required BuildContext context}) =>
      FlutterScreenUtil.ScreenUtil.instance = FlutterScreenUtil.ScreenUtil(
          width: width, height: height, allowFontScaling: allowFontScaling)
        ..init(context);
}

extension ScreenUtilExtension on num {
  double get width => ScreenUtil.ready
      ? FlutterScreenUtil.ScreenUtil.getInstance().setWidth(this).toDouble()
      : this.toDouble();
  double get height => ScreenUtil.ready
      ? FlutterScreenUtil.ScreenUtil.getInstance().setHeight(this).toDouble()
      : this.toDouble();
  double get sp => ScreenUtil.ready
      ? FlutterScreenUtil.ScreenUtil.getInstance().setSp(this).toDouble()
      : this.toDouble();
  double get minWidthHeight => min(width, height);
  double get maxWidthHeight => max(width, height);
}
