import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:rxdart/rxdart.dart';
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

  Future<BehaviorSubject<List<Conversation>>> getConversationList() async {
    int find(List<Conversation> list, int fromUserId) {
      int findIndex = -1;
      for (int i = 0; i < list.length; ++i) {
        if (list[i].fromId == fromUserId) {
          findIndex = i;
          break;
        }
      }
      return findIndex;
    }

    const String storeKey = 'conversation_list';
    const int maxNum = 30;

    final BehaviorSubject<List<Conversation>> subject =
        BehaviorSubject<List<Conversation>>();
    final String cached = StorageUtil.get<String>(storeKey);
    if (cached != null) {
      try {
        final decoded = await worker.jsonDecode<List<dynamic>>(cached);
        final List<Conversation> list = [];
        for (var d in decoded) {
          list.add(Conversation.fromJson(d));
        }
        subject.value = list;
      } catch (_) {
        subject.value = <Conversation>[];
      }
    } else {
      subject.value = <Conversation>[];
    }

    try {
      final UserUnreadMsgSum unreadSum =
          (await _messageService.getUserUnreadMsgSum()).body.result;
      final list = subject.value;
      for (UserUnreadMsgNum unread in unreadSum.list) {
        int findIndex = find(list, unread.fromUserId);
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
      subject.value = list;
    } catch (_) {}

    void _onReceiveUserMessage(WebSocketMessage<UserMessageArg> message) {
      final List<Conversation> list = subject.value;
      // TODO(windrunner414): 可以优化成Map, id: Conversation去掉遍历
      int findIndex = find(list, message.args.fromUserId);
      if (findIndex == -1) {
        final Conversation conversation = Conversation(
          fromId: message.args.fromUserId,
          type: ConversationType.user,
          desc: message.args.msg ?? message.msg, // 如果是获取的未读消息就是args.msg
          updateAt:
              message.args.addTime ?? DateTime.now().millisecondsSinceEpoch,
          unreadMsgCount: 1,
          msgId: message.args.msgId,
        );
        list.insert(0, conversation);
        if (list.length > maxNum) {
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
                  : conversation.unreadMsgCount +
                      1, // args.msg为null时是新接收的不然是拉的未读
              msgId: message.args.msgId,
            ),
          );
        }
      }
      subject.value = list;
    }

    final PublishSubject<WebSocketMessage<UserMessageArg>> userMessages =
        _messageService.receiveUserMessage();
    final StreamSubscription subscription =
        userMessages.listen((WebSocketMessage<UserMessageArg> message) {
      _onReceiveUserMessage(message);
    });

    try {
      final lastUnread = (await _messageService.getUserLastUnreadMessages());
      for (var unread in lastUnread.args.list) {
        _onReceiveUserMessage(
            WebSocketMessage(op: lastUnread.op, args: unread));
      }
    } catch (_) {}

    subject.listen((value) async {
      await StorageUtil.setString(storeKey, await worker.jsonEncode(value));
    }, onDone: () {
      subscription.cancel();
      userMessages.close();
    });

    return subject;
  }
}
