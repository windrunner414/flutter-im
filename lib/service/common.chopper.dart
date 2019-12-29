// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$CommonService extends CommonService {
  _$CommonService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = CommonService;

  @override
  Future<Response<ApiResponse<VerifyCode>>> getVerifyCode() {
    final $url = '/Common/VerifyCode/verifyCode';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponse<VerifyCode>, VerifyCode>($request);
  }
}
