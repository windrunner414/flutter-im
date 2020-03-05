import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/conversation.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_args.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/util/stream.dart';

part 'message.chopper.dart';

@ChopperApi(baseUrl: '/User/Message')
abstract class MessageService extends BaseService {
  static MessageService create([ChopperClient client]) =>
      _$MessageService(client);

  @Get(path: '/UserMessageReadList/getAll')
  Future<Response<ApiResponse<ConversationList>>> getUnReadConversationList();

  @Get(path: '/UserMessage/getAll')
  Future<Response<ApiResponse<MessageList>>> getHistoricalUserMessages({
    @Query() @required int friendUserId,
    @Query() int lastMsgId,
  });

  @Get(path: '/GroupMessage/getAll')
  Future<Response<ApiResponse<MessageList>>> getHistoricalGroupMessages({
    @Query() @required int groupId,
    @Query() int lastMsgId,
  });

  PublishSubject<WebSocketMessage<MessageArg>> receiveUserMessage(
      [int userId]) {
    PublishSubject<WebSocketMessage<MessageArg>> subject =
        webSocketClient.receiveMany<MessageArg>(op: 1101);
    if (userId != null) {
      subject = subject.pipeAndFilter((WebSocketMessage<MessageArg> value) =>
          value.args.fromUserId == userId);
    }
    return subject;
  }

  PublishSubject<WebSocketMessage<MessageArg>> receiveGroupMessage(
      [int groupId]) {
    PublishSubject<WebSocketMessage<MessageArg>> subject =
        webSocketClient.receiveMany<MessageArg>(op: 2101);
    if (groupId != null) {
      subject = subject.pipeAndFilter((WebSocketMessage<MessageArg> value) =>
          value.args.groupId == groupId);
    }
    return subject;
  }

  Future<WebSocketMessage<dynamic>> notifyRead({
    @required int fromId,
    @required int msgId,
    @required int msgType,
  }) {
    return webSocketClient.sendAndReceive(WebSocketMessage(
      op: 4002,
      args: {"msgId": msgId, "fromId": fromId, "msgType": msgType},
    ));
  }

  Future<WebSocketMessage<dynamic>> sendUserMessage({
    @required int toUserId,
    @required String msg,
    @required MessageType msgType,
  }) {
    return webSocketClient.sendAndReceive(WebSocketMessage(
      op: 1001,
      args: {"userId": toUserId},
      msg: msg,
      msgType: msgType,
    ));
  }

  Future<WebSocketMessage<dynamic>> sendGroupMessage({
    int toUserId,
    @required int groupId,
    @required String msg,
    @required MessageType msgType,
  }) {
    return webSocketClient.sendAndReceive(WebSocketMessage(
      op: 2001,
      args: {"groupId": groupId, "userId": toUserId},
      msg: msg,
      msgType: msgType,
    ));
  }
}
