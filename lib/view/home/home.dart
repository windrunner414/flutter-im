import 'package:flutter/material.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/route.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/view/home/contact.dart';
import 'package:wechat/view/home/conversation.dart';
import 'package:wechat/view/home/profile.dart';
import 'package:wechat/viewmodel/home.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/stream_builder.dart';

enum _PopupMenuItems { createGroup, addFriend, scanQrCode }

class HomePage extends BaseView<HomeViewModel> {
  Widget _buildPopupMenuItem(int iconName, String title) => Row(
        children: <Widget>[
          Icon(
            IconData(iconName, fontFamily: Constant.IconFontFamily),
            size: 22.minWidthHeight,
            color: const Color(AppColor.AppBarPopupMenuColor),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: const Color(AppColor.AppBarPopupMenuColor),
              fontSize: 16.sp,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) => Scaffold(
        appBar: IAppBar(
          title: Config.AppName,
          actions: <Widget>[
            PopupMenuButton<_PopupMenuItems>(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<_PopupMenuItems>>[
                PopupMenuItem<_PopupMenuItems>(
                  child: _buildPopupMenuItem(0xe606, '发起群聊'),
                  value: _PopupMenuItems.createGroup,
                ),
                PopupMenuItem<_PopupMenuItems>(
                  child: _buildPopupMenuItem(0xe638, '添加朋友'),
                  value: _PopupMenuItems.addFriend,
                ),
                PopupMenuItem<_PopupMenuItems>(
                  child: _buildPopupMenuItem(0xe79b, '扫一扫'),
                  value: _PopupMenuItems.scanQrCode,
                ),
              ],
              icon: Icon(
                const IconData(0xe66b, fontFamily: Constant.IconFontFamily),
                size: 19.height,
              ),
              onSelected: (_PopupMenuItems selected) {
                switch (selected) {
                  case _PopupMenuItems.addFriend:
                    router.push(Page.addFriend);
                    break;
                  default:
                }
              },
              tooltip: '菜单',
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: PageView.builder(
          itemBuilder: (BuildContext context, int index) => <Widget>[
            ConversationPage(),
            ContactPage(friendApplyNum: viewModel.friendApplyNum),
            ProfilePage(),
          ][index],
          controller: viewModel.pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: 3,
          onPageChanged: (int index) => viewModel.currentIndex.value = index,
        ),
        bottomNavigationBar: IStreamBuilder<int>(
          stream: viewModel.currentIndex,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
              BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: const Text(Config.AppName),
                icon: Icon(
                  const IconData(0xe608, fontFamily: Constant.IconFontFamily),
                  size: 28.sp,
                ),
                activeIcon: Icon(
                  const IconData(0xe603, fontFamily: Constant.IconFontFamily),
                  size: 28.sp,
                ),
              ),
              BottomNavigationBarItem(
                title: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    const Text('通讯录'),
                    IStreamBuilder<int>(
                      stream: viewModel.friendApplyNum,
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) =>
                              Positioned(
                        right: -8,
                        top: -32.sp,
                        child: Offstage(
                          offstage: snapshot.data == 0,
                          child: Container(
                            width: 20.sp,
                            height: 20.sp,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.sp),
                              color: const Color(AppColor.NotifyDotBgColor),
                            ),
                            child: Text(
                              snapshot.data > 99
                                  ? '99+'
                                  : snapshot.data.toString(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(AppColor.NotifyDotText),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                icon: Icon(
                  const IconData(0xe601, fontFamily: Constant.IconFontFamily),
                  size: 28.sp,
                ),
                activeIcon: Icon(
                  const IconData(0xe602, fontFamily: Constant.IconFontFamily),
                  size: 28.sp,
                ),
              ),
              BottomNavigationBarItem(
                title: const Text('我'),
                icon: Icon(
                  const IconData(0xe607, fontFamily: Constant.IconFontFamily),
                  size: 28.sp,
                ),
                activeIcon: Icon(
                  const IconData(0xe630, fontFamily: Constant.IconFontFamily),
                  size: 28.sp,
                ),
              ),
            ],
            currentIndex: snapshot.data,
            type: BottomNavigationBarType.fixed,
            fixedColor: const Color(AppColor.TabIconActive),
            selectedFontSize: 14.sp,
            unselectedFontSize: 14.sp,
            onTap: (int index) => viewModel.pageController.jumpToPage(index),
          ),
        ),
      );
}
