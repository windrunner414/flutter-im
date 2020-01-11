import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/route.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/profile.dart';
import 'package:wechat/widget/full_width_button.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

class _ProfileHeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(vertical: 13.height, horizontal: 20.width),
        child: IStreamBuilder<User>(
          stream: ownUserInfo,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              UImage(
                snapshot.data.userAvatar,
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
                      snapshot.data.userName,
                      style: TextStyle(
                        color: const Color(AppColor.TitleColor),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.height),
                    Text(
                      '账号: ${snapshot.data.userAccount}',
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
                color: Color(AppColor.TabIconNormalColor),
              ),
              SizedBox(width: 5.width),
              Icon(
                const IconData(
                  0xe664,
                  fontFamily: Constant.IconFontFamily,
                ),
                size: 22.minWidthHeight,
                color: Color(AppColor.TabIconNormalColor),
              ),
            ],
          ),
        ),
      );
}

class ProfilePage extends BaseView<ProfileViewModel> {
  static const double SEPARATE_SIZE = 20.0;

  @override
  _ProfilePageState createState() => _ProfilePageState();

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) => ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: SEPARATE_SIZE.height),
          _ProfileHeaderView(),
          SizedBox(height: SEPARATE_SIZE.height),
          FullWidthButton(
            iconPath: 'asset://assets/images/ic_settings.png',
            title: '设置',
            showDivider: true,
            onPressed: () => router.push(Page.setting),
          ),
        ],
      );
}

class _ProfilePageState extends BaseViewState<ProfileViewModel, ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.build(context, viewModel);
  }
}
