import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/viewmodel/base.dart';

enum ChatType { friend, group }

class ChatViewModel extends BaseViewModel {
  ChatViewModel({@required this.id, @required this.type});

  final int id;
  final ChatType type;
  final BehaviorSubject<List<Message>> historicalMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);
  final BehaviorSubject<List<Message>> newMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);

  PublishSubject<WebSocketMessage<UserMessageArg>> _messages;
  final MessageRepository _messageRepository = inject();

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
      Message(fromUserId: 1, msgId: 0, msg: '1', type: MessageType.text),
      Message(fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '1'),
      Message(fromUserId: 1, msgId: 0, msg: '1'),
      Message(fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '1'),
    ];
    _addMessages(_messages, isHistorical: true);
  }

  Future<void> sendMessage(MessageType msgType, String msg) async {
    if (type == ChatType.friend) {
      await _messageRepository.sendUserMessage(
          toUserId: id, msg: msg, msgType: msgType);
    } else {}
    // TODO: 让conversationList更新
    _addMessage(
      Message(
        fromUserId: ownUserInfo.value.userId,
        msg: msg,
        type: msgType,
        msgId: 0,
      ),
    );
  }

  void _notifyRead(int msgId) {
    _messageRepository
        .notifyRead(friendId: id, msgId: msgId)
        .catchError((Object error) {});
  }

  @override
  void init() {
    super.init();
    loadHistoricalMessages();
    if (type == ChatType.friend) {
      _messages = _messageRepository.receiveUserMessage(id);
    } else {
      _messages = _messageRepository.receiveUserMessage(id);
    }
    _messages.listen((value) {
      _addMessage(Message(
        fromUserId: value.args.fromUserId,
        msgId: value.args.msgId,
        msg: value.msg,
        type: value.msgType,
      ));
      _notifyRead(value.args.msgId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    newMessages.close();
    historicalMessages.close();
    _messages.close();
  }
}
