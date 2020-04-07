import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/service/base.dart';

part 'auth.chopper.dart';

@ChopperApi(baseUrl: '/User/Auth')
abstract class AuthService extends BaseService {
  static AuthService create([ChopperClient client]) => _$AuthService(client);

  @Post(path: '/login')
  Future<Response<ApiResponse<User>>> login(
      {@Field() @required String userAccount,
      @Field() @required String userPassword,
      @Field() @required String verifyCodeHash,
      @Field() @required int verifyCodeTime,
      @Field() @required String verifyCode});

  @Post(path: '/register')
  Future<Response<ApiResponse<Object>>> register(
      {@Field() @required String userAccount,
      @Field() @required String userName,
      @Field() @required String userPassword,
      @Field() @required String rePassword,
      @Field() @required String verifyCodeHash,
      @Field() @required int verifyCodeTime,
      @Field() @required String verifyCode});

  @Get(path: '/getInfo')
  Future<Response<ApiResponse<User>>> getSelfInfo();
}
