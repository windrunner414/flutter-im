import 'package:wechat/model/verify_code.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/repository/remote/api.dart';
import 'package:wechat/util/storage.dart';

class AuthRepository extends BaseRepository {
  String getUserSession() => StorageUtil.get("auth.user_session");

  Future<VerifyCode> getVerifyCode() async =>
      (await HttpApiClient().getVerifyCode()).result;
}
