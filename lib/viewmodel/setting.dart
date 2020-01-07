import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/viewmodel/base.dart';

class SettingViewModel extends BaseViewModel {
  void logout() {
    ownUserInfo.value = ownUserInfo.value.copyWith(userSession: '');
  }
}
