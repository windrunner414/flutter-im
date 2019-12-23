import 'dart:convert';

import 'package:wechat/model/api_response.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/repository/remote/api.dart';
import 'package:wechat/util/storage.dart';

class UserRepository extends BaseRepository {
  Future<User> getSelfInfo({bool fromCache = false}) async {
    const String storageKey = "user.self_info";
    if (!fromCache) {
      ApiResponse<User> response = await HttpApiClient().getSelfInfo();
      StorageUtil.setString(storageKey, jsonEncode(response.result));
      return response.result;
    }
    String json = StorageUtil.get(storageKey);
    return json == null ? null : User.fromJson(jsonDecode(json));
  }
}
