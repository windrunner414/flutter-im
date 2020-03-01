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

  static const int conversationListMaxNum = 50;

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

  int _find(List<Conversation> list, int fromUserId) {
    int findIndex = -1;
    for (int i = 0; i < list.length; ++i) {
      if (list[i].fromId == fromUserId) {
        findIndex = i;
        break;
      }
    }
    return findIndex;
  }

  void _onReceiveUserMessage(WebSocketMessage<UserMessageArg> message) {
    final List<Conversation> list = _conversations.value;
    // TODO(windrunner414): 可以优化成Map<String, int>+List<Conversation>, id: index去掉遍历
    int findIndex = _find(list, message.args.fromUserId);
    if (findIndex == -1) {
      final Conversation conversation = Conversation(
        fromId: message.args.fromUserId,
        type: ConversationType.user,
        desc: message.args.msg ?? message.msg, // 如果是获取的未读消息就是args.msg
        updateAt: message.args.addTime ?? DateTime.now().millisecondsSinceEpoch,
        unreadMsgCount: 1,
        msgId: message.args.msgId,
      );
      list.insert(0, conversation);
      if (list.length > conversationListMaxNum) {
        list.removeLast();
      }
    } else {
      if (message.args.msgId > list[findIndex].msgId) {
        final Conversation conversation = list.removeAt(findIndex);
        list.insert(
          0,
          conversation.copyWith(
            desc: message.args.msg ?? message.msg,
            updateAt:
                message.args.addTime ?? DateTime.now().millisecondsSinceEpoch,
            unreadMsgCount: message.args.msg != null
                ? conversation.unreadMsgCount
                : conversation.unreadMsgCount + 1, // args.msg为null时是新接收的不然是拉的未读
            msgId: message.args.msgId,
          ),
        );
      }
    }
    _conversations.value = list;
  }

  Future<void> pullUnreadMessages() async {
    try {
      final UserUnreadMsgSum unreadSum =
          (await _messageService.getUserUnreadMsgSum()).body.result;
      final list = _conversations.value;
      for (UserUnreadMsgNum unread in unreadSum.list) {
        int findIndex = _find(list, unread.fromUserId);
        if (findIndex == -1) {
          list.add(Conversation(
            fromId: unread.fromUserId,
            type: ConversationType.user,
            desc: '',
            updateAt: DateTime.now().millisecondsSinceEpoch,
            unreadMsgCount: unread.num,
            msgId: -1,
          ));
        } else {
          list[findIndex] =
              list[findIndex].copyWith(unreadMsgCount: unread.num);
        }
      }
      _conversations.value = list;

      final lastUnread = (await _messageService.getUserLastUnreadMessages());
      for (var unread in lastUnread.args.list) {
        _onReceiveUserMessage(
            WebSocketMessage(op: lastUnread.op, args: unread));
      }
    } catch (_) {}
  }

  BehaviorSubject<List<Conversation>> getConversationList() => _conversations;
}
