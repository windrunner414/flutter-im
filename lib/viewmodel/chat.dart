import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/viewmodel/base.dart';

enum ChatType { friend, group }

class ChatViewModel extends BaseViewModel {
  ChatViewModel({@required this.id, @required this.type});

  final int id;
  final ChatType type;
  final TextEditingController messageEditingController =
      TextEditingController();
  final BehaviorSubject<List<Message>> historicalMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);
  final BehaviorSubject<List<Message>> newMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);

  int _debug = 0;

  // TODO(windrunner): 限制消息数量，超出一定数量就把之前的删除，需要下拉重新加载，同时限制历史消息加载的最大数量
  void _addMessages(List<Message> list, {bool isHistorical = false}) {
    if (newMessages.isClosed || historicalMessages.isClosed) {
      return;
    }

    if (!isHistorical) {
      newMessages.value = newMessages.value..addAll(list);
    } else {
      historicalMessages.value = historicalMessages.value
        ..addAll(list.reversed);
    }
  }

  Future<void> loadHistoricalMessages() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final List<Message> _messages = <Message>[
      Message(fromUserId: 1, msgId: 0, msg: '${_debug++}'),
      Message(
          fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '${_debug++}'),
      Message(fromUserId: 1, msgId: 0, msg: '${_debug++}'),
      Message(
          fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '${_debug++}'),
    ];
    _addMessages(_messages, isHistorical: true);
  }

  @override
  void init() {
    super.init();
    final List<Message> _messages = <Message>[
      Message(fromUserId: 1, msgId: 0, msg: '${_debug++}'),
      Message(
          fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '${_debug++}'),
      Message(fromUserId: 1, msgId: 0, msg: '${_debug++}'),
      Message(
          fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '${_debug++}'),
      Message(
          fromUserId: ownUserInfo.value.userId,
          msgId: 0,
          msg: 'https://www.baidu.com'),
    ];
    _addMessages(_messages, isHistorical: true);
    //_addNewMessages(_messages);
    //_addNewMessages(_messages);
    /*Timer.periodic(const Duration(milliseconds: 500), (_) {
      final List<Message> _messages = <Message>[
        Message(fromUserId: 1, msgId: 0, msg: '${_debug++}'),
      ];
      _addMessages(_messages);
    });*/
  }

  @override
  void dispose() {
    super.dispose();
    messageEditingController.dispose();
    newMessages.close();
    historicalMessages.close();
  }
}
