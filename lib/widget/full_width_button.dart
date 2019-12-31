import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/util/screen.dart';

class FullWidthButton extends StatelessWidget {
  const FullWidthButton({
    Key key,
    @required this.title,
    @required this.iconPath,
    @required this.onPressed,
    this.showDivider = false,
  })  : assert(iconPath != null),
        assert(title != null),
        assert(onPressed != null),
        super(key: key);

  static const double HORIZONTAL_PADDING = 20.0;
  static const double VERTICAL_PADDING = 13.0;

  final String title;
  final String iconPath;
  final bool showDivider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Widget pureButton = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          iconPath,
          width: Constant.FullWidthIconButtonIconSize.minWidthHeight,
          height: Constant.FullWidthIconButtonIconSize.minWidthHeight,
        ),
        SizedBox(width: HORIZONTAL_PADDING.width),
        Expanded(
          child: Text(title, style: TextStyle(fontSize: 16.sp)),
        ),
        Icon(
          IconData(
            0xe664,
            fontFamily: Constant.IconFontFamily,
          ),
          size: 22.minWidthHeight,
          color: Color(AppColor.TabIconNormal),
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
      ),
      color: Colors.white,
      child: showDivider
          ? Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(AppColor.DividerColor),
                    width: Constant.DividerWidth,
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
