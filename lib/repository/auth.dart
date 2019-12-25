import 'package:dartin/dartin.dart';
import 'package:wechat/app.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/repository/base.dart';
import 'package:wechat/service/auth.dart';

class AuthRepository extends BaseRepository {
  AuthService _authService = inject();

  Future<User> getSelfInfo() async {
    AppState.selfInfo.value = (await _authService.getSelfInfo()).body.result;
    return AppState.selfInfo.value;
  }
}
