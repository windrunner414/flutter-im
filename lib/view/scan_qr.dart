import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';
import 'package:wechat/repository/group.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/view/base.dart';
import 'package:wechat/viewmodel/add_friend.dart';
import 'package:wechat/widget/app_bar.dart';

class ScanQrPage extends StatefulWidget {
  @override
  _ScanQrPageState createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final QRCaptureController qrCaptureController = QRCaptureController();

  @override
  void initState() {
    super.initState();
    qrCaptureController.onCapture((data) async {
      qrCaptureController.pause();
      await _parse(data);
      qrCaptureController.resume();
    });
  }

  Future<void> _parse(String data) async {
    try {
      Uri uri = Uri.parse(data);
      switch (uri.scheme) {
        case 'user':
          final String account = uri.host;
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('添加好友'),
              content: Text('是否发出好友申请？'),
              actions: <Widget>[
                FlatButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text("确定"),
                  onPressed: () {
                    final AddFriendViewModel viewModel = inject();
                    viewModel
                        .addFriend(userAccount: account)
                        .then((value) {
                          showToast('申请成功');
                        })
                        .catchAll((e) {
                          showToast(e.toString());
                        })
                        .showLoadingUntilComplete()
                        .whenComplete(() {
                          Navigator.of(context).pop();
                        });
                  },
                ),
              ],
            ),
          );
          break;
        case 'group':
          final String code = uri.host;
          await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('申请入群'),
              content: Text('是否申请入群？'),
              actions: <Widget>[
                FlatButton(
                  child: Text("取消"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text("确定"),
                  onPressed: () {
                    final GroupRepository _groupRepository = inject();
                    _groupRepository
                        .applyEnter(code: code)
                        .then((value) {
                          showToast('申请成功');
                        })
                        .catchAll((e) {
                          showToast(e.toString());
                        })
                        .showLoadingUntilComplete()
                        .whenComplete(() {
                          Navigator.of(context).pop();
                        });
                  },
                ),
              ],
            ),
          );
          break;
        default:
          showToast('无法解析');
      }
    } catch (e) {
      showToast('无法解析');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IAppBar(title: Text('扫描二维码')),
      body: Container(
        child: QRCaptureView(controller: qrCaptureController),
      ),
    );
  }
}
