import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

class ScreenUtil {
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
  num get width => FlutterScreenUtil.ScreenUtil.getInstance().setWidth(this);
  num get height => FlutterScreenUtil.ScreenUtil.getInstance().setHeight(this);
  num get sp => FlutterScreenUtil.ScreenUtil.getInstance().setSp(this);
  num get minWidthHeight => min(width, height);
  num get maxWidthHeight => max(width, height);
}
