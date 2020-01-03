import 'package:flutter/cupertino.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/viewmodel/base.dart';

class AddFriendViewModel extends BaseViewModel {
  TextEditingController textEditingController = TextEditingController();
  List<User> result = const <User>[];

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
}
