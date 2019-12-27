import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/viewmodel/base.dart';

class ProfileViewModel extends BaseViewModel {
  AuthRepository _authRepository = inject();
  Timer _timer;

  void _refresh() => _authRepository.getSelfInfo().catchError((e) {});

  @override
  void init() {
    super.init();
    _refresh();
    _timer = Timer.periodic(
        Duration(minutes: 1), (Timer timer) => _refresh()); //TODO:handleError
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
