import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/edit_profile.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/image.dart';
import 'package:wechat/widget/stream_builder.dart';

class EditProfilePage extends BaseView<EditProfileViewModel> {
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
            right,
          ],
        ),
      ),
    );
  }

  Future<void> _editUserName(BuildContext context, String current,
      EditProfileViewModel viewModel) async {
    final TextEditingController textEditingController =
        TextEditingController.fromValue(TextEditingValue(text: current));
    final bool save = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('修改用户名'),
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
        viewModel.update(userName: new_).catchAll(
          (e) {
            showToast(e.toString());
          },
          test: exceptCancelException,
        ).showLoadingUntilComplete();
      }
    }
  }

  Future<void> _editPassword(
      BuildContext context, EditProfileViewModel viewModel) async {
    final TextEditingController textEditingController = TextEditingController();
    final TextEditingController confirm = TextEditingController();
    final bool save = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('修改密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: '请输入新密码'),
              obscureText: true,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: confirm,
              decoration: InputDecoration(hintText: '请再次输入密码'),
              obscureText: true,
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text("确定"),
            onPressed: () {
              if (confirm.text != textEditingController.text) {
                showToast('两次输入不一致');
              } else if (confirm.text.isEmpty) {
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
      viewModel
          .update(userPassword: textEditingController.text)
          .then((_) => showToast('修改成功'))
          .catchAll(
        (e) {
          showToast(e.toString());
        },
        test: exceptCancelException,
      ).showLoadingUntilComplete();
    }
  }

  Future<void> _editAvatar(EditProfileViewModel viewModel) async {
    try {
      var resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
      );
      var result = resultList[0];
      List<int> bytes =
          (await result.getByteData(quality: 80)).buffer.asUint8List();
      viewModel.update(userAvatar: bytes).catchAll(
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

  Widget build(BuildContext context, EditProfileViewModel viewModel) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(title: const Text('编辑个人信息')),
      body: Container(
        color: const Color(AppColor.BackgroundColor),
        padding: const EdgeInsets.only(top: 16),
        child: IStreamBuilder(
          stream: ownUserInfo,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            return Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _editAvatar(viewModel),
                  child: _column(
                    '头像',
                    Row(
                      children: <Widget>[
                        UImage(
                          snapshot.data.userAvatar,
                          placeholderBuilder: (BuildContext context) => UImage(
                            'asset://assets/images/default_avatar.png',
                            width: 60.sp,
                            height: 60.sp,
                          ),
                          width: 60.sp,
                          height: 60.sp,
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 26,
                          color: Color(AppColor.TabIconNormalColor),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      _editUserName(context, snapshot.data.userName, viewModel),
                  child: _column(
                    '用户名',
                    Row(
                      children: <Widget>[
                        Text(
                          snapshot.data.userName,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.only(top: 3), // emm
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: 26,
                            color: Color(AppColor.TabIconNormalColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => router.push('/businessCard'),
                  child: _column(
                    '二维码名片',
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
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _editPassword(context, viewModel),
                  child: _column(
                    '修改密码',
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 26,
                      color: Color(AppColor.TabIconNormalColor),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
