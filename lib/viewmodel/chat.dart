import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/state.dart';
import 'package:wechat/viewmodel/base.dart';

enum ChatType { FRIEND, GROUP }

class ChatViewModel extends BaseViewModel {
  ChatViewModel({@required this.id, @required this.type});

  final int id;
  final ChatType type;
  final TextEditingController messageEditingController =
      TextEditingController();
  final BehaviorSubject<List<Message>> messages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);

  void _addMessages(List<Message> list) {
    messages.value = messages.value..addAll(list);
  }

  void _addMessage(Message message) {
    messages.value = messages.value..add(message);
  }

  Future<void> loadMore() async {
    print('loadMore');
    await Future<void>.delayed(const Duration(seconds: 1));
    _addMessages(<Message>[
      const Message(fromUserId: 1, msgId: 0, msg: '测试消息123'),
      Message(
          fromUserId: ownUserInfo.value.userId,
          msgId: 0,
          msg: '行路难！行路难！多歧路，今安在？长风破浪会有时，直挂云帆济沧海。'),
      const Message(fromUserId: 1, msgId: 0, msg: '这是别人发的消息'),
      Message(
          fromUserId: ownUserInfo.value.userId,
          msgId: 0,
          msg: '君不见黄河之水天上来,奔流到海不复回。君不见高堂明镜悲白发,朝如青丝暮成雪。'),
    ]);
  }

  @override
  void init() {
    super.init();
    final List<Message> _messages = <Message>[
      const Message(fromUserId: 1, msgId: 0, msg: '测试消息123'),
      Message(
          fromUserId: ownUserInfo.value.userId,
          msgId: 0,
          msg: '行路难！行路难！多歧路，今安在？长风破浪会有时，直挂云帆济沧海。'),
      const Message(fromUserId: 1, msgId: 0, msg: '这是别人发的消息'),
      Message(
          fromUserId: ownUserInfo.value.userId,
          msgId: 0,
          msg: '君不见黄河之水天上来,奔流到海不复回。君不见高堂明镜悲白发,朝如青丝暮成雪。'),
    ];
    _addMessages(_messages);
  }

  @override
  void dispose() {
    super.dispose();
    messageEditingController.dispose();
    messages.close();
  }
}
