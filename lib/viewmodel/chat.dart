import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/repository/file.dart';
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
  final FileRepository _fileRepository = inject();

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

  // TODO: 让conversationList更新
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
          fromUserId: 1,
          msgId: 0,
          msg:
              '1111111111111111111111111111111111111111111111111111111111111111111111',
          type: MessageType.text),
      Message(fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '1'),
      Message(fromUserId: 1, msgId: 0, msg: '1'),
      Message(fromUserId: ownUserInfo.value.userId, msgId: 0, msg: '1'),
    ];
    _addMessages(_messages, isHistorical: true);
  }

  Future<void> _sendMessage(Message message) async {
    try {
      message.sendState.value = SendState.sending;
      if (message.msg.isEmpty) {
        if (message.type == MessageType.image) {
          message.msg = await _fileRepository.uploadFile(
            MultipartFile.fromBytes(
              'file',
              message.bytes,
              filename: 'image.jpg',
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }
      if (type == ChatType.friend) {
        await _messageRepository.sendUserMessage(
            toUserId: id, msg: message.msg, msgType: message.type);
      } else {}
      message.sendState.value = SendState.success;
    } catch (_) {
      message.sendState.value = SendState.failed;
    }
  }

  void reSend(Message message) {
    _sendMessage(message);
  }

  void sendText(String msg) {
    final Message message = Message(
      fromUserId: ownUserInfo.value.userId,
      msg: msg,
      type: MessageType.text,
      msgId: 0,
      sendState: BehaviorSubject(),
    );
    _sendMessage(message);
    _addMessage(message);
  }

  void sendImage(List<int> bytes) {
    Message message = Message(
      fromUserId: ownUserInfo.value.userId,
      msg: '',
      type: MessageType.image,
      msgId: 0,
      bytes: bytes,
      sendState: BehaviorSubject(),
    );
    _sendMessage(message);
    _addMessage(message);
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
