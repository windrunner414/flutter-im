import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/service/message.dart';
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

  PublishSubject<WebSocketMessage<UserMessageArg>> _messages;
  final MessageService _messageService = inject();

  int _readNum = 0;
  int get readNum => _readNum;
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

  void _addMessage(Message message, {bool isHistorical = false}) {
    if (newMessages.isClosed || historicalMessages.isClosed) {
      return;
    }

    if (!isHistorical) {
      newMessages.value = newMessages.value..add(message);
    } else {
      historicalMessages.value = historicalMessages.value..add(message);
    }
  }

  Future<void> loadHistoricalMessages() async {
    final List<Message> _messages = <Message>[
      Message(
          fromUserId: 1, msgId: 0, msg: '${_debug++}', type: MessageType.text),
      Message(
          fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '${_debug++}'),
      Message(fromUserId: 1, msgId: 0, msg: '${_debug++}'),
      Message(
          fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '${_debug++}'),
    ];
    _addMessages(_messages, isHistorical: true);
  }

  void _notifyRead(int msgId) {
    ++_readNum;
    _messageService.notifyRead(msgId).catchError((Object error) {});
  }

  @override
  void init() {
    super.init();
    loadHistoricalMessages();
    if (type == ChatType.friend) {
      _messages = _messageService.receiveUserMessage(id);
    } else {
      _messages = _messageService.receiveUserMessage(id);
    }
    _messages.listen((value) {
      _addMessage(Message(
        fromUserId: value.args.fromUserId,
        msgId: value.args.msgId,
        msg: value.msg,
        type: Message.fromJson({'type': value.msgType}).type,
      ));
      _notifyRead(value.args.msgId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageEditingController.dispose();
    newMessages.close();
    historicalMessages.close();
    _messages.close();
  }
}
