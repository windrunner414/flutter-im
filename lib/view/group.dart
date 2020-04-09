import 'dart:math';

import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/model/group_user.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/group.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

class GroupPage extends BaseView<GroupViewModel> {
  GroupPage(this.id);

  final int id;

  @override
  _GroupPageState createState() => _GroupPageState();

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

  // TODO: 可以抽出来复用的，先copy了
  Future<void> _editGroupName(
      BuildContext context, String current, GroupViewModel viewModel) async {
    final TextEditingController textEditingController =
        TextEditingController.fromValue(TextEditingValue(text: current));
    final bool save = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('修改群聊名称'),
        content: TextField(
          controller: textEditingController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("确定"),
            onPressed: () {
              if (textEditingController.text.isEmpty) {
                showToast('不能为空');
              } else {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
    );
    if (save == true) {
      final new_ = textEditingController.text;
      if (current != new_) {
        viewModel.update(groupName: new_).catchAll(
          (e) {
            showToast(e.toString());
          },
          test: exceptCancelException,
        ).showLoadingUntilComplete();
      }
    }
  }

  Future<void> _editNickName(
      BuildContext context, String current, GroupViewModel viewModel) async {
    final TextEditingController textEditingController =
        TextEditingController.fromValue(TextEditingValue(text: current));
    final bool save = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('修改我在本群的昵称'),
        content: TextField(
          controller: textEditingController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("确定"),
            onPressed: () {
              if (textEditingController.text.isEmpty) {
                showToast('不能为空');
              } else {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
    );
    if (save == true) {
      final new_ = textEditingController.text;
      if (current != new_) {
        viewModel.updateNickName(new_).catchAll(
          (e) {
            showToast(e.toString());
          },
          test: exceptCancelException,
        ).showLoadingUntilComplete();
      }
    }
  }

  Future<void> _editGroupAvatar(GroupViewModel viewModel) async {
    try {
      var resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );
      var result = resultList[0];
      List<int> bytes =
          (await result.getByteData(quality: 80)).buffer.asUint8List();
      viewModel.update(groupAvatar: bytes).catchAll(
        (e) {
          showToast(e.toString());
        },
        test: exceptCancelException,
      ).showLoadingUntilComplete();
    } on NoImagesSelectedException {
      // ignore
    } catch (_) {
      showToast('请检查权限');
    }
  }

  void _showQRCode(GroupViewModel viewModel) {
    showWidget(
      builder: (_) {
        return Center(
          child: Container(
            color: Colors.white,
            child: QrImage(
              data: 'group://' + viewModel.info.value.code.toString(),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
              size: 196,
              errorStateBuilder: (BuildContext context, Object error) =>
                  const Text(
                '啊哦，出错了',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        );
      },
      clickClose: true,
      crossPage: false,
    );
  }

  void _inviteFriends(BuildContext context, GroupViewModel viewModel) {
    List<User> users = [];
    Set<int> groupUsers =
        viewModel.users.value.list.map((e) => e.userId).toSet();
    for (var e in friendList.value.list) {
      if (groupUsers.contains(e.targetUserId)) {
        continue;
      }
      users.add(User(
        userId: e.targetUserId,
        userAvatar: e.userAvatar,
        userName: e.showName,
      ));
    }
    _selectUser(context, users, (users) {
      return viewModel.invite(users).then((_) {
        showToast('已发送邀请');
        return true;
      }).catchAll(
        (e) {
          showToast(e.toString());
          return false;
        },
        test: exceptCancelException,
      ).showLoadingUntilComplete();
    });
  }

  Future<bool> _deleteUsers(
      BuildContext context, GroupViewModel viewModel) async {
    List<User> users = [];
    for (var e in viewModel.users.value.list) {
      if (e.userId == ownUserInfo.value.userId) {
        continue;
      }
      users.add(User(
        userId: e.userId,
        userAvatar: e.userAvatar,
        userName: e.showName,
      ));
    }
    _selectUser(context, users, (users) {
      return viewModel.deleteUsers(users).then((_) {
        showToast('操作成功');
        return true;
      }).catchAll(
        (e) {
          showToast(e.toString());
          return false;
        },
        test: exceptCancelException,
      ).showLoadingUntilComplete();
    });
  }

  _selectUser(
    BuildContext context,
    List<User> users,
    Future<bool> callback(Set<User> users),
  ) {
    BehaviorSubject<Set<User>> selected = BehaviorSubject.seeded({});
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Scaffold(
            appBar: IAppBar(
              title: Text('邀请好友'),
              actions: <Widget>[
                ButtonTheme(
                  minWidth: 0,
                  child: FlatButton(
                    onPressed: () async {
                      if (selected.value.length > 0) {
                        if (!(await callback(selected.value))) {
                          return;
                        }
                      }
                      router.pop();
                    },
                    child: Text(
                      '确定',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    color: const Color(AppColor.LoginInputNormalColor),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            body: IStreamBuilder(
              stream: selected,
              builder: (BuildContext context, _) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 12),
                          UImage(
                            users[index].userAvatar,
                            placeholderBuilder: (BuildContext context) =>
                                UImage(
                              'asset://assets/images/default_avatar.png',
                              width: 36,
                              height: 36,
                            ),
                            width: 36,
                            height: 36,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            users[index].userName,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Checkbox(
                                value: selected.value.contains(users[index])
                                    ? true
                                    : false,
                                onChanged: (value) {
                                  if (selected.value.length >= 10) {
                                    showToast('一次最多选择10个');
                                    return;
                                  }
                                  if (value) {
                                    selected.value = selected.value
                                      ..add(users[index]);
                                  } else {
                                    selected.value = selected.value
                                      ..remove(users[index]);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: users.length,
                );
              },
            ),
          ),
        );
      },
    );
  }

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
                      min(users.total, isManager ? 23 : 25),
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
                    )..addAll(isManager
                        ? [
                            Center(
                              child: GestureDetector(
                                onTap: () => _inviteFriends(context, viewModel),
                                child: Icon(
                                  Icons.add,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () => _deleteUsers(context, viewModel),
                                child: Icon(
                                  Icons.remove,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ]
                        : const []),
                  ),
                ),
                GestureDetector(
                  onTap: () => router.push(
                    '/groupMembers',
                    arguments: <String, String>{'id': id.toString()},
                  ),
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '查看全部成员',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (isManager)
                  GestureDetector(
                    onTap: () =>
                        _editGroupName(context, group.groupName, viewModel),
                    child: _column('群聊名称', Text(group.groupName)),
                  )
                else
                  _column('群聊名称', Text(group.groupName)),
                if (isManager)
                  GestureDetector(
                    onTap: () => _editGroupAvatar(viewModel),
                    child: _column(
                      '群聊头像',
                      UImage(
                        group.groupAvatar,
                        placeholderBuilder: (BuildContext context) => UImage(
                          'asset://assets/images/default_avatar.png',
                          width: 48,
                          height: 48,
                        ),
                        width: 48,
                        height: 48,
                      ),
                    ),
                  )
                else
                  _column(
                    '群聊头像',
                    UImage(
                      group.groupAvatar,
                      placeholderBuilder: (BuildContext context) => UImage(
                        'asset://assets/images/default_avatar.png',
                        width: 56,
                        height: 56,
                      ),
                      width: 56,
                      height: 56,
                    ),
                  ),
                GestureDetector(
                  onTap: () => _showQRCode(viewModel),
                  child: _column(
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
                ),
                if (isManager && false) // TODO: hide this now
                  _column(
                    '禁言',
                    CupertinoSwitch(
                      value: group.isForbidden,
                      onChanged: (bool value) {
                        viewModel.update(isSpeakForbidden: value).catchAll(
                          (e) {
                            showToast(e.toString());
                          },
                          test: exceptCancelException,
                        ).showLoadingUntilComplete();
                      },
                    ),
                  ),
                const SizedBox(height: 8),
                GestureDetector(
                  // 这里应该默认为userGroupName而非showName
                  onTap: () =>
                      _editNickName(context, me.userGroupName, viewModel),
                  child: _column('我在本群的昵称', Text(me.showName)),
                ),
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
