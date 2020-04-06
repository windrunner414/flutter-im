import 'dart:math';

import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/group.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

Widget _column(String text, Widget right) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: const Color(AppColor.DividerColor),
          width: 0.5,
        ),
      ),
    ),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(color: Colors.black87, fontSize: 18),
          ),
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
            child: right,
          ),
        ],
      ),
    ),
  );
}

class GroupPage extends BaseView<GroupViewModel> {
  GroupPage(this.id);

  final int id;

  @override
  _GroupPageState createState() => _GroupPageState();

  @override
  Widget build(BuildContext context, GroupViewModel viewModel) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(title: const Text('群聊信息')),
      body: IStreamBuilder(
        stream: Rx.merge(<Stream>{viewModel.info, viewModel.users}),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!viewModel.users.hasValue || !viewModel.info.hasValue) {
            return Container();
          }
          final Group group = viewModel.info.value;
          final GroupUserList users = viewModel.users.value;
          GroupUser me;
          for (var i in users.list) {
            if (i.userId == ownUserInfo.value.userId) {
              me = i;
              break;
            }
          }
          final bool isManager = me.userId == group.manageUserId;
          return Container(
            color: const Color(AppColor.BackgroundColor),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      min(users.total, 23),
                      (index) => Center(
                        child: GestureDetector(
                          onTap: () => router.push(
                            '/user',
                            arguments: <String, String>{
                              'userId': users.list[index].userId.toString(),
                              'groupId': id.toString(),
                            },
                          ),
                          child: UImage(
                            users.list[index].userAvatar,
                            placeholderBuilder: (BuildContext context) =>
                                UImage(
                              'asset://assets/images/default_avatar.png',
                              width: 56,
                              height: 56,
                            ),
                            width: 56,
                            height: 56,
                          ),
                        ),
                      ),
                    )..addAll([
                        Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.add,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.remove,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ]),
                  ),
                ),
                const SizedBox(height: 8),
                _column('群聊名称', Text(group.groupName)),
                _column(
                  '群二维码',
                  Icon(
                    const IconData(
                      0xe620,
                      fontFamily: Constant.IconFontFamily,
                    ),
                    size: 26,
                    color: Color(AppColor.TabIconNormalColor),
                  ),
                ),
                if (isManager)
                  _column(
                    '禁言',
                    CupertinoSwitch(
                      value: group.isForbidden,
                      onChanged: (bool value) {
                        viewModel.updateForbidden(value).catchAll(
                          (e) {
                            showToast(e.toString());
                          },
                          test: exceptCancelException,
                        ).showLoadingUntilComplete();
                      },
                    ),
                  ),
                const SizedBox(height: 8),
                _column('我在本群的昵称', Text(me.showName)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    color: Colors.white,
                    splashColor: Colors.transparent,
                    onPressed: () =>
                        (isManager ? viewModel.delete() : viewModel.leave())
                            .then((_) {
                      router.pop();
                      router.pop();
                    }).catchAll(
                      (e) {
                        showToast(e.toString());
                      },
                      test: exceptCancelException,
                    ).showLoadingUntilComplete(),
                    child: Text(
                      isManager ? '解散群聊' : '退出群聊',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GroupPageState extends BaseViewState<GroupViewModel, GroupPage> {
  @override
  void initState() {
    super.initState();
    viewModel.refresh().catchAll(
      (e) {
        showToast(e.toString());
      },
      test: exceptCancelException,
    ).showLoadingUntilComplete();
  }

  @override
  GroupViewModel createViewModel() => inject(params: [widget.id]);
}
