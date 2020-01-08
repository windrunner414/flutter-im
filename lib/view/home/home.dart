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
  final List<Widget> _pages = <Widget>[
    ConversationPage(),
    ContactPage(),
    ProfilePage(),
  ];

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
          itemBuilder: (BuildContext context, int index) => _pages[index],
          controller: viewModel.pageController,
          physics: const BouncingScrollPhysics(),
          itemCount: _pages.length,
          onPageChanged: (int index) => viewModel.currentIndex.value = index,
        ),
        bottomNavigationBar: IStreamBuilder<int>(
          stream: viewModel.currentIndex,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
              BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: Text(Config.AppName),
                icon:
                    Icon(IconData(0xe608, fontFamily: Constant.IconFontFamily)),
                activeIcon:
                    Icon(IconData(0xe603, fontFamily: Constant.IconFontFamily)),
              ),
              BottomNavigationBarItem(
                title: Text('通讯录'),
                icon:
                    Icon(IconData(0xe601, fontFamily: Constant.IconFontFamily)),
                activeIcon:
                    Icon(IconData(0xe602, fontFamily: Constant.IconFontFamily)),
              ),
              BottomNavigationBarItem(
                title: Text('我'),
                icon:
                    Icon(IconData(0xe607, fontFamily: Constant.IconFontFamily)),
                activeIcon:
                    Icon(IconData(0xe630, fontFamily: Constant.IconFontFamily)),
              ),
            ],
            currentIndex: snapshot.data ?? 0,
            type: BottomNavigationBarType.fixed,
            fixedColor: const Color(AppColor.TabIconActive),
            selectedFontSize: 14.sp,
            unselectedFontSize: 14.sp,
            onTap: (int index) => viewModel.pageController.jumpToPage(index),
          ),
        ),
      );
}
