import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/route.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/home/contact.dart';
import 'package:wechat/view/home/conversation.dart';
import 'package:wechat/view/home/profile.dart';
import 'package:wechat/widget/app_bar.dart';

enum _PopupMenuItems { GROUP_CHAT, ADD_FRIEND, QR_SCAN }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _pages = <Widget>[
    ConversationPage(),
    ContactPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    webSocketClient.connect();
  }

  @override
  void dispose() {
    super.dispose();
    webSocketClient.close();
  }

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
  Widget build(BuildContext context) => Scaffold(
        appBar: IAppBar(
          title: Config.AppName,
          actions: <Widget>[
            PopupMenuButton<_PopupMenuItems>(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<_PopupMenuItems>>[
                PopupMenuItem<_PopupMenuItems>(
                  child: _buildPopupMenuItem(0xe606, '发起群聊'),
                  value: _PopupMenuItems.GROUP_CHAT,
                ),
                PopupMenuItem<_PopupMenuItems>(
                  child: _buildPopupMenuItem(0xe638, '添加朋友'),
                  value: _PopupMenuItems.ADD_FRIEND,
                ),
                PopupMenuItem<_PopupMenuItems>(
                  child: _buildPopupMenuItem(0xe79b, '扫一扫'),
                  value: _PopupMenuItems.QR_SCAN,
                ),
              ],
              icon: Icon(
                const IconData(0xe66b, fontFamily: Constant.IconFontFamily),
                size: 21.height,
              ),
              onSelected: (_PopupMenuItems selected) {
                switch (selected) {
                  case _PopupMenuItems.ADD_FRIEND:
                    router.push(Page.AddFriend);
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
          controller: _pageController,
          itemCount: _pages.length,
          onPageChanged: (int index) => setState(() => _currentIndex = index),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text(Config.AppName),
              icon: Icon(IconData(0xe608, fontFamily: Constant.IconFontFamily)),
              activeIcon:
                  Icon(IconData(0xe603, fontFamily: Constant.IconFontFamily)),
            ),
            BottomNavigationBarItem(
              title: Text('通讯录'),
              icon: Icon(IconData(0xe601, fontFamily: Constant.IconFontFamily)),
              activeIcon:
                  Icon(IconData(0xe602, fontFamily: Constant.IconFontFamily)),
            ),
            BottomNavigationBarItem(
              title: Text('我'),
              icon: Icon(IconData(0xe607, fontFamily: Constant.IconFontFamily)),
              activeIcon:
                  Icon(IconData(0xe630, fontFamily: Constant.IconFontFamily)),
            ),
          ],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: const Color(AppColor.TabIconActive),
          selectedFontSize: 14.sp,
          unselectedFontSize: 14.sp,
          onTap: (int index) => _pageController.jumpToPage(index),
        ),
      );
}