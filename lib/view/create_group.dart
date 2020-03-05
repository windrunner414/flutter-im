import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/util/router.dart';
import 'package:wechat/util/screen.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/create_group.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/login_input.dart';
import 'package:wechat/widget/stream_builder.dart';
import 'package:wechat/widget/unfocus_scope.dart';

class CreateGroupPage extends BaseView<CreateGroupViewModel> {
  @override
  Widget build(BuildContext context, CreateGroupViewModel viewModel) {
    dependOnScreenUtil(context);
    return Scaffold(
      appBar: IAppBar(title: const Text('发起群聊')),
      body: UnFocusScope(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    try {
                      final assets = await MultiImagePicker.pickImages(
                          maxImages: 1, enableCamera: true);
                      if (assets.length == 1) {
                        var asset = assets[0];
                        var byteData = await asset.getThumbByteData(128, 128);
                        viewModel.groupAvatarBytes.value =
                            byteData.buffer.asUint8List();
                      }
                    } catch (_) {}
                  },
                  child: Column(
                    children: <Widget>[
                      IStreamBuilder(
                        stream: viewModel.groupAvatarBytes,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<int>> snapshot) {
                          return ExtendedImage(
                            image: (snapshot.hasData
                                    ? ExtendedMemoryImageProvider(snapshot.data)
                                    : ExtendedAssetImageProvider(
                                        'assets/images/default_avatar.png'))
                                as ImageProvider,
                            width: 100,
                            height: 100,
                            filterQuality: FilterQuality.low,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Text('选择头像',
                          style:
                              TextStyle(fontSize: 18, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                LoginInput(
                  label: '群名',
                  controller: viewModel.groupNameEditingController,
                ),
                const SizedBox(height: 15),
                FlatButton(
                  onPressed: () {
                    viewModel.create().then((_) {
                      showToast('创建成功');
                      router.pop();
                    }).catchAll(
                      (Object error) {
                        showToast(error.toString());
                      },
                      test: exceptCancelException,
                    ).showLoadingUntilComplete();
                  },
                  color: const Color(AppColor.LoginInputActiveColor),
                  padding: EdgeInsets.symmetric(vertical: 10.height),
                  child: Center(
                    child: Text(
                      '创建',
                      style: TextStyle(fontSize: 20.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
