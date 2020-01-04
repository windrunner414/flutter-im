// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$UserService extends UserService {
  _$UserService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = UserService;

  @override
  Future<Response<ApiResponse<UserList>>> search(
      {String keyword, int page, int limit}) {
    final $url = '/User/User/getAll';
    final $params = <String, dynamic>{
      'keyword': keyword,
      'page': page,
      'limit': limit
    };
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse<UserList>, UserList>($request);
  }
}
