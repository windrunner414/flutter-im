import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/widget/image.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton({
    Key key,
    @required this.title,
    this.iconPath,
    @required this.onPressed,
    this.showDivider = false,
    this.padding = EdgeInsets.zero,
  })  : assert(title != null),
        assert(onPressed != null),
        super(key: key);

  static const double HORIZONTAL_PADDING = 20.0;
  static const double VERTICAL_PADDING = 13.0;

  final Widget title;
  final String iconPath;
  final bool showDivider;
  final VoidCallback onPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    final Widget pureButton = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (iconPath != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: UImage(
              iconPath,
              width: 24.sp,
              height: 24.sp,
            ),
          ),
          const SizedBox(width: HORIZONTAL_PADDING),
        ],
        Expanded(
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            child: title,
          ),
        ),
        Icon(
          const IconData(
            0xe664,
            fontFamily: Constant.IconFontFamily,
          ),
          size: 22.minWidthHeight,
          color: const Color(AppColor.TabIconNormalColor),
        ),
      ],
    );

    return FlatButton(
      onPressed: onPressed,
      padding: EdgeInsets.only(
            left: HORIZONTAL_PADDING.width,
            right: HORIZONTAL_PADDING.width,
            top: VERTICAL_PADDING.height,
            bottom: showDivider ? 0 : VERTICAL_PADDING.height,
          ) +
          padding,
      color: Colors.white,
      splashColor: Colors.transparent,
      child: showDivider
          ? Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(AppColor.DividerColor),
                    width: 0.5,
                  ),
                ),
              ),
              padding: const EdgeInsets.only(bottom: VERTICAL_PADDING),
              child: pureButton,
            )
          : pureButton,
    );
  }
}
