import 'package:dartin/dartin.dart';
import 'package:flutter/material.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/user.dart';

class UserRepository extends BaseRepository {
  final UserService _userService = inject();

  Future<UserList> search({
    @required String keyword,
    @required int page,
    @required int limit,
  }) async =>
      (await _userService.search(keyword: keyword, page: page, limit: limit))
          .body
          .result;
}
