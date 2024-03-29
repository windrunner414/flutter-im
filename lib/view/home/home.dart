import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/contacts.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/contact.dart';
import 'package:wechat/viewmodel/conversation.dart';
import 'package:wechat/viewmodel/home.dart';
import 'package:wechat/viewmodel/profile.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/contact_item.dart';
import 'package:wechat/widget/friend_user_info.dart';
import 'package:wechat/widget/full_width_button.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/joined_group_info.dart';
import 'package:wechat/widget/stream_builder.dart';

part 'contact.dart';
part 'conversation.dart';
part 'profile.dart';

enum _PopupMenuItems { createGroup, addFriend, scanQrCode }

class HomePage extends BaseView<HomeViewModel> {
  Widget _buildPopupMenuItem(int iconName, String title) => Builder(
        builder: (BuildContext context) {
          dependOnScreenUtil(context);
          return Row(
            children: <Widget>[
              Icon(
                IconData(iconName, fontFamily: Constant.IconFontFamily),
                size: 22.sp,
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
        },
      );

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    dependOnScreenUtil(context);
    final List<Widget> pages = <Widget>[
      _ConversationPage(),
      _ContactPage(
        friendApplicationNum: viewModel.friendApplicationNum,
        groupApplicationNum: viewModel.groupApplicationNum,
        groupInvitationNum: viewModel.groupInvitationNum,
      ),
      _ProfilePage(),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (!kIsWeb && Platform.isAndroid) {
          const MethodChannel('android.move_task_to_back')
              .invokeMethod<void>('moveTaskToBack');
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: IAppBar(
          title: const Text(Config.AppName),
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
                    router.push('/addFriend');
                    break;
                  case _PopupMenuItems.createGroup:
                    router.push('/createGroup');
                    break;
                  case _PopupMenuItems.scanQrCode:
                    router.push('/scanQrCode');
                    break;
                }
              },
              tooltip: '菜单',
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Container(
          color: const Color(AppColor.BackgroundColor),
          child: PageView.builder(
            itemBuilder: (BuildContext context, int index) => pages[index],
            controller: viewModel.pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: 3,
            onPageChanged: (int index) => viewModel.currentIndex.value = index,
          ),
        ),
        bottomNavigationBar: IStreamBuilder<int>(
          stream: viewModel.currentIndex,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            Widget buildContactIcon(bool active) => IStreamBuilder<int>(
                  initialData: 0,
                  stream: Rx.combineLatest<int, int>(
                    <Stream<int>>{
                      viewModel.friendApplicationNum,
                      viewModel.groupApplicationNum,
                      viewModel.groupInvitationNum,
                    },
                    (List<int> list) => list.fold(0, (v, e) => v + e),
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot<int> snapshot) =>
                          Badge(
                    child: Icon(
                      IconData(active ? 0xe602 : 0xe601,
                          fontFamily: Constant.IconFontFamily),
                      size: 28.sp,
                    ),
                    elevation: 0,
                    badgeColor: const Color(AppColor.NotifyDotBgColor),
                    badgeContent: Text(
                      snapshot.data > 99 ? '99+' : snapshot.data.toString(),
                      style: TextStyle(
                        color: const Color(AppColor.NotifyDotTextColor),
                        fontSize: 14.sp,
                      ),
                    ),
                    toAnimate: false,
                    padding: const EdgeInsets.all(7),
                    showBadge: snapshot.data > 0,
                  ),
                );

            return BottomNavigationBar(
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
                  title: const Text('通讯录'),
                  icon: buildContactIcon(false),
                  activeIcon: buildContactIcon(true),
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
              fixedColor: const Color(AppColor.TabIconActiveColor),
              selectedFontSize: 14.sp,
              unselectedFontSize: 14.sp,
              onTap: (int index) => viewModel.pageController.jumpToPage(index),
            );
          },
        ),
      ),
    );
  }
}
