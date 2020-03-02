// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_friend.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$UserFriendService extends UserFriendService {
  _$UserFriendService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserFriendService;

  @override
  Future<Response<ApiResponse<FriendList>>> getAll() {
    final $url = '/User/UserFriend/getAll';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponse<FriendList>, FriendList>($request);
  }
}
