import 'dart:async';
import 'dart:convert';

import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/message.dart';
import 'package:wechat/util/storage.dart';
import 'package:wechat/util/worker/worker.dart';

class MessageRepository extends BaseRepository {
  final MessageService _messageService = inject();

  static BehaviorSubject<List<Conversation>> _conversations;
  static String get conversationListStorageKey =>
      'conversation_list_${ownUserInfo.value.userId}';

  static const int conversationListMaxLength = 100;

  void initConversationList() {
    disposeConversationList();

    final String cached = StorageUtil.get<String>(conversationListStorageKey);
    if (cached != null) {
      try {
        final decoded = jsonDecode(cached); // 同步加载
        final List<Conversation> list = [];
        for (var d in decoded) {
          list.add(Conversation.fromJson(d));
        }
        _conversations.value = list;
      } catch (_) {
        _conversations.value = <Conversation>[];
      }
    } else {
      _conversations.value = <Conversation>[];
    }

    final PublishSubject<WebSocketMessage<UserMessageArg>> userMessages =
        _messageService.receiveUserMessage();

    userMessages.listen((WebSocketMessage<UserMessageArg> message) {
      _onReceiveUserMessage(message);
    });

    _conversations.listen((value) async {
      await StorageUtil.setString(
          conversationListStorageKey, await worker.jsonEncode(value));
    }, onDone: () {
      if (!userMessages.isClosed) {
        userMessages.close();
      }
    });
  }

  void disposeConversationList() {
    _conversations?.close();
    _conversations = BehaviorSubject();
  }

  int _find(List<Conversation> list, int fromId, ConversationType type) {
    int findIndex = -1;
    for (int i = 0; i < list.length; ++i) {
      if (list[i].fromId == fromId && list[i].type == type) {
        findIndex = i;
        break;
      }
    }
    return findIndex;
  }

  void _onReceiveUserMessage(WebSocketMessage<UserMessageArg> message) {
    final List<Conversation> list = _conversations.value;
    int findIndex =
        _find(list, message.args.fromUserId, ConversationType.friend);
    if (findIndex == -1) {
      final Conversation conversation = Conversation(
        fromId: message.args.fromUserId,
        type: ConversationType.friend,
        msg: message.msg,
        updateAt: DateTime.now().millisecondsSinceEpoch,
        unreadMsgNum: 1,
        msgType: message.msgType,
      );
      list.insert(0, conversation);
      if (list.length > conversationListMaxLength) {
        list.removeLast();
      }
    } else {
      final Conversation conversation = list.removeAt(findIndex);
      list.insert(
        0,
        conversation.copyWith(
          msg: message.msg,
          updateAt: DateTime.now().millisecondsSinceEpoch,
          unreadMsgNum: conversation.unreadMsgNum + 1,
          msgType: message.msgType,
        ),
      );
    }
    _conversations.value = list;
  }

  Future<void> pullUnreadMessages() async {
    final list = _conversations.value;
    final List<Conversation> conversations =
        (await _messageService.getUnReadConversationList()).body.result.list;
    for (var conversation in conversations) {
      int findIndex = _find(list, conversation.fromId, conversation.type);
      if (findIndex == -1) {
        list.add(conversation);
      } else {
        list[findIndex] = conversation;
      }
    }
    list.sort((Conversation a, Conversation b) => b.updateAt - a.updateAt);
    if (list.length > conversationListMaxLength) {
      list.removeRange(conversationListMaxLength, list.length);
    }
    _conversations.value = list;
  }

  BehaviorSubject<List<Conversation>> getConversationList() => _conversations;

  PublishSubject<WebSocketMessage<UserMessageArg>> receiveUserMessage(
          [int fromUserId]) =>
      _messageService.receiveUserMessage(fromUserId);

  Future<WebSocketMessage<dynamic>> sendUserMessage(
          {int toUserId, String msg, MessageType msgType}) =>
      _messageService.sendUserMessage(
          toUserId: toUserId, msgType: msgType, msg: msg);

  Future<WebSocketMessage<dynamic>> notifyRead(
          {int fromId, int msgId, ConversationType type}) =>
      _messageService.notifyRead(
        fromId: fromId,
        msgId: msgId,
        msgType: type == ConversationType.friend ? 1 : 2,
      );

  Future<MessageList> getHistoricalUserMessages(
          {int friendUserId, int lastMsgId}) async =>
      (await _messageService.getHistoricalUserMessages(
              friendUserId: friendUserId, lastMsgId: lastMsgId))
          .body
          .result;
}
