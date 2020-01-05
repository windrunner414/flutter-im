import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/route.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/profile.dart';
import 'package:wechat/widget/full_width_button.dart';
import 'package:wechat/widget/image.dart';

class _ProfileHeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(vertical: 13.height, horizontal: 20.width),
        child: StreamBuilder<User>(
          stream: ownUserInfo,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            final User info = ownUserInfo.value;
            if (info == null) {
              return Container();
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                UImage(
                  info.userAvatar,
                  placeholder: Icon(
                    const IconData(
                      0xe642,
                      fontFamily: Constant.IconFontFamily,
                    ),
                    size: 60.sp,
                  ),
                  width: 60.sp,
                  height: 60.sp,
                ),
                SizedBox(width: 10.width),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        info.userName,
                        style: TextStyle(
                          color: const Color(AppColor.TitleColor),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.height),
                      Text(
                        '账号: ${info.userAccount}',
                        style: TextStyle(
                          color: const Color(AppColor.DescTextColor),
                          fontSize: 13.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Icon(
                  const IconData(
                    0xe620,
                    fontFamily: Constant.IconFontFamily,
                  ),
                  size: 22.minWidthHeight,
                  color: Color(AppColor.TabIconNormal),
                ),
                SizedBox(width: 5.width),
                Icon(
                  const IconData(
                    0xe664,
                    fontFamily: Constant.IconFontFamily,
                  ),
                  size: 22.minWidthHeight,
                  color: Color(AppColor.TabIconNormal),
                ),
              ],
            );
          },
        ),
      );
}

class ProfilePage extends BaseView<ProfileViewModel> {
  @override
  bool get keepAlive => true;

  static const double SEPARATE_SIZE = 20.0;

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) => Container(
        color: const Color(AppColor.BackgroundColor),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: SEPARATE_SIZE.height),
              _ProfileHeaderView(),
              SizedBox(height: SEPARATE_SIZE.height),
              FullWidthButton(
                iconPath: 'asset://assets/images/ic_settings.png',
                title: '设置',
                showDivider: true,
                onPressed: () => router.push(Page.Setting),
              ),
            ],
          ),
        ),
      );
}
