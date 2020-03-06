import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/model/friend.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/user.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/full_width_button.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/stream_builder.dart';

class _ProfileHeaderView extends StatelessWidget {
  _ProfileHeaderView(this.user, this.showName);

  final User user;
  final String showName;

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding:
            EdgeInsets.symmetric(vertical: 13.height, horizontal: 20.width),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UImage(
              user.userAvatar,
              placeholderBuilder: (BuildContext context) => UImage(
                'asset://assets/images/default_avatar.png',
                width: 60.sp,
                height: 60.sp,
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
                    showName,
                    style: TextStyle(
                      color: const Color(AppColor.TitleColor),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.height),
                  if (showName != user.userName) ...[
                    Text(
                      '昵称: ${user.userName}',
                      style: TextStyle(
                        color: const Color(AppColor.DescTextColor),
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 5.height),
                  ],
                  Text(
                    '账号: ${user.userAccount}',
                    style: TextStyle(
                      color: const Color(AppColor.DescTextColor),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

enum _PopupMenuItems { delete }

class UserPage extends BaseView<UserViewModel> {
  UserPage({this.userId, this.groupId});

  final int userId;
  final int groupId;

  @override
  _UserPageState createState() => _UserPageState();

  @override
  Widget build(BuildContext context, UserViewModel viewModel) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(
        title: Text('用户信息'),
        actions: <Widget>[
          groupId == null
              ? _buildFriendMenu(context, viewModel)
              : _buildGroupMenu(context, viewModel),
        ],
      ),
      body: Container(
        color: Color(AppColor.BackgroundColor),
        child: groupId == null
            ? _buildFriend(context, viewModel)
            : _buildGroup(context, viewModel),
      ),
    );
  }

  Widget _buildPopupMenuItem(String title) => Builder(
        builder: (BuildContext context) {
          dependOnScreenUtil(context);
          return Row(
            children: <Widget>[
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

  Widget _buildFriendMenu(BuildContext context, UserViewModel viewModel) {
    return PopupMenuButton<_PopupMenuItems>(
      itemBuilder: (BuildContext context) => <PopupMenuItem<_PopupMenuItems>>[
        PopupMenuItem<_PopupMenuItems>(
          child: _buildPopupMenuItem('删除好友'),
          value: _PopupMenuItems.delete,
        ),
      ],
      icon: Icon(
        const IconData(0xe66b, fontFamily: Constant.IconFontFamily),
        size: 19.height,
      ),
      onSelected: (_PopupMenuItems selected) {
        switch (selected) {
          case _PopupMenuItems.delete:
            viewModel
                .deleteFriend()
                .then((_) => router.pop())
                .catchAll(
                  (Object e) => showToast(e.toString()),
                  test: exceptCancelException,
                )
                .showLoadingUntilComplete();
            break;
          default:
        }
      },
      tooltip: '菜单',
    );
  }

  Widget _buildGroupMenu(BuildContext context, UserViewModel viewModel) {
    return PopupMenuButton<_PopupMenuItems>(
      itemBuilder: (BuildContext context) => <PopupMenuItem<_PopupMenuItems>>[
        PopupMenuItem<_PopupMenuItems>(
          child: _buildPopupMenuItem('退出群聊'),
          value: _PopupMenuItems.delete,
        ),
      ],
      icon: Icon(
        const IconData(0xe66b, fontFamily: Constant.IconFontFamily),
        size: 19.height,
      ),
      onSelected: (_PopupMenuItems selected) {
        switch (selected) {
          case _PopupMenuItems.delete:
            break;
          default:
        }
      },
      tooltip: '菜单',
    );
  }

  Widget _buildFriend(BuildContext context, UserViewModel viewModel) {
    return IStreamBuilder(
      stream: viewModel.friendData,
      builder: (BuildContext context, AsyncSnapshot<Friend> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              '无数据',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
              ),
            ),
          );
        }
        return Column(
          children: <Widget>[
            _ProfileHeaderView(
              User(
                userName: snapshot.data.targetUserName,
                userAccount: snapshot.data.targetUserAccount,
                userAvatar: snapshot.data.userAvatar,
                userId: snapshot.data.targetUserId,
              ),
              snapshot.data.showName,
            ),
            const SizedBox(height: 15),
            FullWidthButton(
              padding: const EdgeInsets.symmetric(vertical: 2),
              onPressed: () async {
                final String remark =
                    await _editRemark(context, snapshot.data.remark);
                if (remark != null) {
                  viewModel.updateFriendRemark(remark).catchAll(
                    (Object e) {
                      showToast(e.toString());
                    },
                    test: exceptCancelException,
                  ).showLoadingUntilComplete();
                }
              },
              title: Text('修改备注'),
              showDivider: true,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '拉黑好友',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                  CupertinoSwitch(
                    value:
                        snapshot.data.state == FriendState.black ? true : false,
                    onChanged: (bool value) {
                      viewModel
                          .updateFriendState(
                              value ? FriendState.black : FriendState.normal)
                          .catchAll(
                            (Object e) => showToast(e.toString()),
                            test: exceptCancelException,
                          )
                          .showLoadingUntilComplete();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                splashColor: Colors.transparent,
                onPressed: () {
                  router.push('/chat', arguments: <String, String>{
                    'id': userId.toString(),
                    'type': 'friend',
                  });
                },
                child: Text(
                  '发送消息',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroup(BuildContext context, UserViewModel viewModel) {}

  Future<String> _editRemark(BuildContext context, String currentRemark) async {
    currentRemark ??= '';
    final TextEditingController textEditingController =
        TextEditingController.fromValue(TextEditingValue(text: currentRemark));
    final bool saved = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 8,
                  ),
                  child: Stack(
                    children: <Widget>[
                      LoginInput(
                        controller: textEditingController,
                        label: '备注',
                        contentPadding: const EdgeInsets.only(right: 100),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 14,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(
                            '确定',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                          color: const Color(AppColor.LoginInputNormalColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 6),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    if (saved == true) {
      final newRemark = textEditingController.text;
      if (currentRemark != newRemark) {
        return newRemark;
      } else {
        return null;
      }
    }
    return null;
  }
}

class _UserPageState extends BaseViewState<UserViewModel, UserPage> {
  @override
  UserViewModel createViewModel() =>
      inject(params: [widget.userId, widget.groupId]);

  @override
  void initState() {
    super.initState();
    viewModel.getInfo().catchAll(
      (Object e) {
        showToast(e.toString());
      },
      test: exceptCancelException,
    ).showLoadingUntilComplete();
  }
}
