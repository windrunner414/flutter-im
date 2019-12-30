import 'package:flutter/material.dart';
import 'package:wechat/constant.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/screen_util.dart';
import 'package:wechat/view/home/contact.dart';
import 'package:wechat/view/home/conversation.dart';
import 'package:wechat/view/home/profile.dart';

enum _ActionItems { GROUP_CHAT, ADD_FRIEND, QR_SCAN }

class NavigationIconView {
  final BottomNavigationBarItem item;

  NavigationIconView(
      {Key key, String title, IconData icon, IconData activeIcon})
      : item = new BottomNavigationBarItem(
            icon: Icon(icon),
            activeIcon: Icon(activeIcon),
            title: Text(title),
            backgroundColor: Colors.white);
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  List<Widget> _pages;
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;

  @override
  void initState() {
    super.initState();
    Service.webSocketClient.connect();
    _navigationViews = [
      NavigationIconView(
        title: Config.AppName,
        icon: IconData(0xe608, fontFamily: Constant.IconFontFamily),
        activeIcon: IconData(0xe603, fontFamily: Constant.IconFontFamily),
      ),
      NavigationIconView(
        title: '通讯录',
        icon: IconData(0xe601, fontFamily: Constant.IconFontFamily),
        activeIcon: IconData(0xe602, fontFamily: Constant.IconFontFamily),
      ),
      NavigationIconView(
        title: '我',
        icon: IconData(0xe607, fontFamily: Constant.IconFontFamily),
        activeIcon: IconData(0xe630, fontFamily: Constant.IconFontFamily),
      ),
    ];
    _pageController = PageController(initialPage: _currentIndex);
    _pages = [
      ConversationPage(),
      ContactPage(),
      ProfilePage(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    Service.webSocketClient.close();
  }

  _buildPopupMenuItem(int iconName, String title) {
    return Row(
      children: <Widget>[
        Icon(
          IconData(iconName, fontFamily: Constant.IconFontFamily),
          size: 22.0,
          color: Color(AppColor.AppBarPopupMenuColor),
        ),
        Container(width: 12.0),
        Text(
          title,
          style: TextStyle(color: Color(AppColor.AppBarPopupMenuColor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
      items:
          _navigationViews.map((NavigationIconView view) => view.item).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      fixedColor: Color(AppColor.TabIconActive),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(_currentIndex);
        });
      },
    );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight.height),
          child: AppBar(
            title: Text(Config.AppName),
            elevation: 0.0,
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return <PopupMenuItem<_ActionItems>>[
                    PopupMenuItem(
                      child: _buildPopupMenuItem(0xe606, "发起群聊"),
                      value: _ActionItems.GROUP_CHAT,
                    ),
                    PopupMenuItem(
                      child: _buildPopupMenuItem(0xe638, "添加朋友"),
                      value: _ActionItems.ADD_FRIEND,
                    ),
                    PopupMenuItem(
                      child: _buildPopupMenuItem(0xe79b, "扫一扫"),
                      value: _ActionItems.QR_SCAN,
                    )
                  ];
                },
                icon: Icon(
                  IconData(0xe66b, fontFamily: Constant.IconFontFamily),
                  size: 22.0,
                ),
                onSelected: (_ActionItems selected) {
                  print('点击的是$selected');
                },
                tooltip: "菜单",
              ),
              SizedBox(width: 16.0)
            ],
          )),
      body: PageView.builder(
        itemBuilder: (BuildContext context, int index) {
          return _pages[index];
        },
        controller: _pageController,
        itemCount: _pages.length,
        onPageChanged: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: bottomNavBar,
    );
  }
}
