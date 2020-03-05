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

    final PublishSubject<Message> messages = receiveMessage();
    messages.listen(updateConversation);

    _conversations.listen((value) async {
      await StorageUtil.setString(
          conversationListStorageKey, await worker.jsonEncode(value));
    }, onDone: () {
      if (!messages.isClosed) {
        messages.close();
      }
    });
  }

  void disposeConversationList() {
    _conversations?.close();
    _conversations = BehaviorSubject();
  }

  int findInConversationList(
    List<Conversation> list,
    int fromId,
    ConversationType type,
  ) {
    int findIndex = -1;
    for (int i = 0; i < list.length; ++i) {
      if (list[i].fromId == fromId && list[i].type == type) {
        findIndex = i;
        break;
      }
    }
    return findIndex;
  }

  void updateConversation(Message message, {bool addUnreadMsgNum = true}) {
    final List<Conversation> list = _conversations.value;
    final ConversationType type = message.groupId != null
        ? ConversationType.group
        : ConversationType.friend;
    int findIndex = findInConversationList(list, message.conversationId, type);
    if (findIndex == -1) {
      final Conversation conversation = Conversation(
        fromId: message.conversationId,
        type: type,
        msg: message.msg,
        updateAt: DateTime.now().toUtc().millisecondsSinceEpoch,
        unreadMsgNum: addUnreadMsgNum ? 1 : 0,
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
          updateAt: DateTime.now().toUtc().millisecondsSinceEpoch,
          unreadMsgNum: addUnreadMsgNum ? conversation.unreadMsgNum + 1 : null,
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
      int findIndex =
          findInConversationList(list, conversation.fromId, conversation.type);
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

  PublishSubject<Message> receiveMessage({int userId, int groupId}) {
    assert(userId == null || groupId == null);
    PublishSubject<Message> subject = PublishSubject();
    PublishSubject<WebSocketMessage<MessageArg>> user;
    PublishSubject<WebSocketMessage<MessageArg>> group;
    if (userId == null && groupId == null) {
      user = _messageService.receiveUserMessage();
      group = _messageService.receiveGroupMessage();
    } else if (userId != null) {
      user = _messageService.receiveUserMessage(userId);
    } else {
      group = _messageService.receiveGroupMessage(groupId);
    }
    if (user != null) {
      user.listen((value) {
        if (!subject.isClosed) {
          subject.add(Message(
            fromUserId: value.args.fromUserId,
            toUserId: value.args.toUserId,
            groupId: value.args.groupId,
            msgId: value.args.msgId,
            msg: value.msg,
            msgType: value.msgType,
          ));
        }
      }, onError: (Object e) {
        if (!subject.isClosed) {
          subject.addError(e);
        }
      }, onDone: () {
        if (!subject.isClosed) {
          subject.close();
        }
      });
    }
    if (group != null) {
      group.listen((value) {
        if (!subject.isClosed) {
          subject.add(Message(
            fromUserId: value.args.fromUserId,
            toUserId: value.args.toUserId,
            groupId: value.args.groupId,
            msgId: value.args.msgId,
            msg: value.msg,
            msgType: value.msgType,
          ));
        }
      }, onError: (Object e) {
        if (!subject.isClosed) {
          subject.addError(e);
        }
      }, onDone: () {
        if (!subject.isClosed) {
          subject.close();
        }
      });
    }
    subject.done.then((_) {
      if (user != null && !user.isClosed) {
        user.close();
      }
      if (group != null && !group.isClosed) {
        group.close();
      }
    });
    return subject;
  }

  Future<WebSocketMessage<dynamic>> sendMessage(Message message) {
    if (message.groupId == null) {
      return _messageService.sendUserMessage(
        toUserId: message.toUserId,
        msgType: message.msgType,
        msg: message.msg,
      );
    } else {
      return _messageService.sendGroupMessage(
        groupId: message.groupId,
        msg: message.msg,
        msgType: message.msgType,
        toUserId: message.toUserId,
      );
    }
  }

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
