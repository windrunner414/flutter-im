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
  Future<Response<ApiResponse<dynamic>>> addFriend({int userId, String note}) {
    final $url = '/User/UserFriendApply/addFriend';
    final $body = <String, dynamic>{'userId': userId, 'note': note};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse<dynamic>, ApiResponse<dynamic>>($request);
  }

  @override
  Future<Response<ApiResponse<FriendApplicationList>>> getFriendApplicationList(
      {int page, int limit, int state}) {
    final $url = '/User/UserFriendApply/getFriendApplyList';
    final $params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'state': state
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse<FriendApplicationList>,
        FriendApplicationList>($request);
  }

  @override
  Future<Response<ApiResponse<dynamic>>> verify(
      {int friendApplyId, int state, String note}) {
    final $url = '/User/UserFriendApply/verify';
    final $body = <String, dynamic>{
      'friendApplyId': friendApplyId,
      'state': state,
      'note': note
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse<dynamic>, ApiResponse<dynamic>>($request);
  }
}
