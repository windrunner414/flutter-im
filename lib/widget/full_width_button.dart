import 'package:flutter/material.dart';
import 'package:wechat/constants.dart';
import 'package:wechat/util/screen_util.dart';

class FullWidthButton extends StatelessWidget {
  static const HORIZONTAL_PADDING = 20.0;
  static const VERTICAL_PADDING = 13.0;

  FullWidthButton({
    Key key,
    @required this.title,
    @required this.iconPath,
    @required this.onPressed,
    this.showDivider = false,
  })  : assert(iconPath != null),
        assert(title != null),
        assert(onPressed != null),
        super(key: key);

  final String title;
  final String iconPath;
  final bool showDivider;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final pureButton = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          iconPath,
          width: Constants.FullWidthIconButtonIconSize.minWidthHeight,
          height: Constants.FullWidthIconButtonIconSize.minWidthHeight,
        ),
        SizedBox(width: HORIZONTAL_PADDING.width),
        Expanded(
          child: Text(title),
        ),
        Icon(
          IconData(
            0xe664,
            fontFamily: Constants.IconFontFamily,
          ),
          size: 22.minWidthHeight,
          color: Color(AppColors.TabIconNormal),
        ),
      ],
    );

    final borderButton = Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Color(AppColors.DividerColor),
                width: Constants.DividerWidth)),
      ),
      padding: EdgeInsets.only(bottom: VERTICAL_PADDING),
      child: pureButton,
    );

    return FlatButton(
      onPressed: () {},
      padding: EdgeInsets.only(
          left: HORIZONTAL_PADDING.width,
          right: HORIZONTAL_PADDING.width,
          top: VERTICAL_PADDING.height,
          bottom: showDivider ? 0.0 : VERTICAL_PADDING.height),
      color: Colors.white,
      child: showDivider ? borderButton : pureButton,
    );
  }
}
