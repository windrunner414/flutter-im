// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$AuthService extends AuthService {
  _$AuthService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = AuthService;

  @override
  Future<Response<ApiResponse<User>>> login(
      {String userAccount,
      String userPassword,
      String verifyCodeHash,
      int verifyCodeTime,
      String verifyCode}) {
    final $url = '/User/Auth/login';
    final $body = <String, dynamic>{
      'userAccount': userAccount,
      'userPassword': userPassword,
      'verifyCodeHash': verifyCodeHash,
      'verifyCodeTime': verifyCodeTime,
      'verifyCode': verifyCode
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse<User>, User>($request);
  }

  @override
  Future<Response<ApiResponse<User>>> getSelfInfo() {
    final $url = '/User/Auth/getInfo';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponse<User>, User>($request);
  }
}
