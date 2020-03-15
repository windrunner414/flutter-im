import 'dart:async';
import 'dart:io';

import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/repository/file.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/util/worker/worker.dart';
import 'package:wechat/viewmodel/base.dart';

class ChatViewModel extends BaseViewModel {
  ChatViewModel({@required this.id, @required this.type});

  final int id;
  final ConversationType type;

  final BehaviorSubject<List<Message>> historicalMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);
  final BehaviorSubject<List<Message>> newMessages =
      BehaviorSubject<List<Message>>.seeded(<Message>[]);

  PublishSubject<Message> _messages;
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
        .getHistoricalMessages(id: id, lastMsgId: _lastMsgId, type: type)
        .bindTo(this, 'loadHistoricalMessages');

    if (first) {
      if (newMessages.isClosed) {
        return;
      }

      /// 滤重，找出获取的记录中最新的一条消息在新接收的消息中排在第几位，然后去掉这么多条消息
      var latestMessage = list.list.first;
      bool find = false;
      int i = 0;
      for (var nm in newMessages.value) {
        if (++i >= list.list.length) {
          break;
        }
        if (latestMessage.msgId == nm.msgId) {
          find = true;
          break;
        }
      }
      Iterable<Message> add = list.list.reversed;
      if (find) {
        add = add.take(list.list.length - i);
      }
      newMessages.value = newMessages.value..insertAll(0, add);
      _lastMsgId = newMessages.value.first.msgId - 1;

      _notifyRead(list.list.first.msgId);
    } else {
      _lastMsgId = list.list.last.msgId - 1;
      _addMessages(list.list, isHistorical: true);
    }
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

      switch (message.msgType) {
        case MessageType.image:
          if (message.msg.isEmpty) {
            message.msg = await worker.jsonEncode({
              "src": await _fileRepository
                  .uploadImage(
                    // TODO:不要直接把图片全读出来再传和显示，浪费内存
                    MultipartFile.fromBytes(
                      'file',
                      message.data,
                      filename: 'image.jpg',
                      contentType: MediaType('image', 'jpeg'),
                    ),
                  )
                  .bindTo(this)
            });
          }
          break;
        case MessageType.audio:
          var msg = await worker.jsonDecode(message.msg);
          if (msg['src'] == null) {
            final File file = message.data;
            msg['src'] = await _fileRepository
                .uploadVoice(
                  await MultipartFile.fromPath(
                    'file',
                    file.path,
                    filename: 'voice.aac',
                    contentType: MediaType('audio', 'aac'),
                  ),
                )
                .bindTo(this);
            message.msg = await worker.jsonEncode(msg);
            message.data = null;
            file.delete();
          }
          break;
        default:
      }

      /// 不bindTo，一直等到返回结果，如果成功了就updateConversation
      await _messageRepository.sendMessage(message);

      message.sendState.value = SendState.success;
      message.sendState.close();
      _messageRepository.updateConversation(message, addUnreadMsgNum: false);
    } catch (_) {
      message.sendState.value = SendState.failed;
      message.sendState.close();
    }
  }

  void reSend(Message message) {
    _sendMessage(message, true);
  }

  void send(Message message) {
    if (type == ConversationType.group) {
      message = message.copyWith(
        groupId: id,
        fromUserId: ownUserInfo.value.userId,
      );
    } else {
      message = message.copyWith(
        toUserId: id,
        fromUserId: ownUserInfo.value.userId,
      );
    }
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
    _messages = _messageRepository.receiveMessage(id: id, type: type)
      ..listen((value) {
        _addMessage(value);
        _notifyRead(value.msgId);
      });
  }

  @override
  void dispose() {
    super.dispose();

    final conversationsSubject = _messageRepository.getConversationList();
    final List<Conversation> conversations = conversationsSubject.value;
    final int index =
        _messageRepository.findInConversationList(conversations, id, type);

    if (index != -1) {
      conversations[index] = conversations[index].copyWith(unreadMsgNum: 0);
      conversationsSubject.value = conversations;
    }

    newMessages.close();
    historicalMessages.close();
    _messages.close();
  }
}
