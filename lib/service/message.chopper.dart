// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$MessageService extends MessageService {
  _$MessageService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = MessageService;

  @override
  Future<Response<ApiResponse<UserUnreadMsgSum>>> getUserUnreadMsgSum() {
    final $url = '/User/Message/UserMessage/getUnReadMsgSum';
    final $request = Request('GET', $url, client.baseUrl);
    return client
        .send<ApiResponse<UserUnreadMsgSum>, UserUnreadMsgSum>($request);
  }

  @override
  Future<Response<ApiResponse>> notifyRead({int friendId, int msgId}) {
    final $url = '/User/Message/UserMessage/clearUnReadMsg';
    final $body = <String, dynamic>{'friendId': friendId, 'msgId': msgId};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }
}
