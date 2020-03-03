import 'package:chopper/chopper.dart';
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
    @Query() int friendUserId,
    @Query() int lastMsgId,
  });

  PublishSubject<WebSocketMessage<UserMessageArg>> receiveUserMessage(
      [int fromUserId]) {
    final subject = webSocketClient.receiveMany<UserMessageArg>(op: 1101);
    if (fromUserId != null) {
      return subject.pipeAndFilter((WebSocketMessage<UserMessageArg> value) =>
          value.args.fromUserId == fromUserId);
    }
    return subject;
  }

  Future<WebSocketMessage<dynamic>> notifyRead({
    int fromId,
    int msgId,
    int msgType,
  }) {
    return webSocketClient.sendAndReceive(WebSocketMessage(
      op: 4002,
      args: {"msgId": msgId, "fromId": fromId, "msgType": msgType},
    ));
  }

  Future<WebSocketMessage<dynamic>> sendUserMessage(
      {int toUserId, String msg, MessageType msgType}) {
    return webSocketClient.sendAndReceive(WebSocketMessage(
        op: 1001, args: {"userId": toUserId}, msg: msg, msgType: msgType));
  }
}
