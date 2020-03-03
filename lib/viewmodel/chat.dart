import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/repository/file.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/viewmodel/base.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel({@required this.id, @required this.type});

  final int id;
  final ConversationType type;
  final BehaviorSubject<List<Message>> historicalMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);
  final BehaviorSubject<List<Message>> newMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);

  PublishSubject<WebSocketMessage<UserMessageArg>> _messages;
  final MessageRepository _messageRepository = inject();
  final FileRepository _fileRepository = inject();

  int _lastMsgId;

  void _addMessages(Iterable<Message> list, {bool isHistorical = false}) {
    if (newMessages.isClosed || historicalMessages.isClosed) {
      return;
    }

    if (!isHistorical) {
      newMessages.value = newMessages.value..addAll(list);
    } else {
      historicalMessages.value = historicalMessages.value..addAll(list);
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

  Future<void> loadHistoricalMessages(bool first) async {
    final MessageList list = await _messageRepository
        .getHistoricalUserMessages(friendUserId: id, lastMsgId: _lastMsgId)
        .bindTo(this, 'loadHistoricalMessages');
    _lastMsgId = list.list.last.msgId;
    _addMessages(first ? list.list.reversed : list.list, isHistorical: !first);
  }

  Future<void> _sendMessage(Message message, [bool isReSend = false]) async {
    try {
      if (message.sendState != null && !message.sendState.isClosed) {
        message.sendState.close();
      }
      message.sendState = BehaviorSubject.seeded(SendState.sending);
      if (!isReSend) {
        _addMessage(message);
      }
      if (message.msg.isEmpty) {
        if (message.msgType == MessageType.image) {
          message.msg = await _fileRepository
              .uploadFile(
                MultipartFile.fromBytes(
                  'file',
                  message.data,
                  filename: 'image.jpg',
                  contentType: MediaType('image', 'jpeg'),
                ),
              )
              .bindTo(this);
        }
      }
      if (type == ConversationType.friend) {
        await _messageRepository
            .sendUserMessage(
                toUserId: id, msg: message.msg, msgType: message.msgType)
            .bindTo(this);
      } else {}
      message.sendState.value = SendState.success;
      message.sendState.close();
    } catch (_) {
      message.sendState.value = SendState.failed;
      message.sendState.close();
    }
  }

  void reSend(Message message) {
    _sendMessage(message, true);
  }

  void sendText(String msg) {
    final Message message = Message(
      fromUserId: ownUserInfo.value.userId,
      msg: msg,
      msgType: MessageType.text,
    );
    _sendMessage(message);
  }

  void sendImage(List<int> bytes) {
    Message message = Message(
      fromUserId: ownUserInfo.value.userId,
      msg: '',
      msgType: MessageType.image,
      data: bytes,
    );
    _sendMessage(message);
  }

  void _notifyRead(int msgId) {
    _messageRepository
        .notifyRead(fromId: id, msgId: msgId, type: type)
        .catchError((Object error) {});
  }

  @override
  void init() {
    super.init();
    if (type == ConversationType.friend) {
      _messages = _messageRepository.receiveUserMessage(id);
    } else {
      _messages = _messageRepository.receiveUserMessage(id);
    }
    _messages.listen((value) {
      _addMessage(Message(
        fromUserId: value.args.fromUserId,
        msgId: value.args.msgId,
        msg: value.msg,
        msgType: value.msgType,
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
