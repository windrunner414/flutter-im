import 'package:chopper/chopper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/api_response.dart';
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

  @Get(path: '/UserMessage/getUnReadMsgSum')
  Future<Response<ApiResponse<UserUnreadMsgSum>>> getUserUnreadMsgSum();

  PublishSubject<WebSocketMessage<UserMessageArg>> receiveUserMessage(
      [int fromUserId]) {
    final subject = webSocketClient.receiveMany<UserMessageArg>(op: 1101);
    if (fromUserId != null) {
      return subject.pipeAndFilter((WebSocketMessage<UserMessageArg> value) =>
          value.args.fromUserId == fromUserId);
    }
    return subject;
  }

  Future<WebSocketMessage<UserUnreadMessagesArg>> getUserLastUnreadMessages() {
    return webSocketClient.sendAndReceive(
        WebSocketMessage(op: 4001, args: {"userId": null, "size": 1}));
  }

  Future<WebSocketMessage<dynamic>> notifyRead(int msgId) {
    return webSocketClient
        .sendAndReceive(WebSocketMessage(op: 4002, args: {"msgId": msgId}));
  }
}
