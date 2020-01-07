// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_friend_apply.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$UserFriendApplyService extends UserFriendApplyService {
  _$UserFriendApplyService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserFriendApplyService;

  @override
  Future<Response<ApiResponse<dynamic>>> addFriend({int userId}) {
    final $url = '/User/UserFriendApply/addFriend';
    final $body = <String, dynamic>{'userId': userId};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse<dynamic>, ApiResponse<dynamic>>($request);
  }
}
