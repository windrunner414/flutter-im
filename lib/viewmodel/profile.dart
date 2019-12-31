import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/viewmodel/base.dart';

class ProfileViewModel extends BaseViewModel {
  final AuthRepository _authRepository = inject();
  Timer _timer;

  void _refresh() =>
      _authRepository.getSelfInfo().catchError((Object error) {});

  @override
  void init() {
    super.init();
    _refresh();
    _timer = Timer.periodic(const Duration(minutes: 1),
        (Timer timer) => _refresh()); // TODO(windrunner): handleError
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
