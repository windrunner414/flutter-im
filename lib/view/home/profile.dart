import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/state.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/profile.dart';
import 'package:wechat/widget/full_width_button.dart';

class _ProfileHeaderView extends StatelessWidget {
  static const HORIZONTAL_PADDING = 20;
  static const VERTICAL_PADDING = 13;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            vertical: VERTICAL_PADDING.height,
            horizontal: HORIZONTAL_PADDING.width),
        child: StreamBuilder(
          stream: AppState.ownUserInfo,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: snapshot.data.userAvatar,
                  placeholder: (context, url) =>
                      Constant.ProfileAvatarDefaultIcon,
                  width: Constant.ProfileHeaderIconSize.minWidthHeight,
                  height: Constant.ProfileHeaderIconSize.minWidthHeight,
                ),
                SizedBox(width: 10.width),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data.userName,
                        style: TextStyle(
                          color: Color(AppColor.TitleColor),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10.height),
                      Text(
                        "账号: ${snapshot.data.userAccount}",
                        style: TextStyle(
                          color: Color(AppColor.DescTextColor),
                          fontSize: 13.sp,
                        ),
                      )
                    ],
                  ),
                ),
                Icon(
                  IconData(
                    0xe620,
                    fontFamily: Constant.IconFontFamily,
                  ),
                  size: 22.minWidthHeight,
                  color: Color(AppColor.TabIconNormal),
                ),
                SizedBox(width: 5.width),
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
          },
        ),
      );
}

class ProfilePage extends BaseView<ProfileViewModel> {
  @override
  final bool keepAlive = true;

  static const SEPARATE_SIZE = 20;

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) => Container(
        color: Color(AppColor.BackgroundColor),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: SEPARATE_SIZE.height),
              _ProfileHeaderView(),
              SizedBox(height: SEPARATE_SIZE.height),
              FullWidthButton(
                iconPath: 'assets/images/ic_settings.png',
                title: '设置',
                showDivider: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
}
