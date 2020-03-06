import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/widget/app_bar.dart';

class BusinessCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: IAppBar(title: const Text('个人名片')),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Center(
              child: QrImage(
                data: 'user://' + ownUserInfo.value.userAccount.toString(),
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
          ],
        ),
      );
}
