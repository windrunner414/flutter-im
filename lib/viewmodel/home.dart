import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/model/friend_apply.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/viewmodel/base.dart';

class HomeViewModel extends BaseViewModel {
  final AuthRepository _authRepository = inject();
  final UserFriendApplyRepository _userFriendApplyRepository = inject();

  final BehaviorSubject<int> currentIndex = BehaviorSubject<int>.seeded(0);
  final PageController pageController = PageController(initialPage: 0);
  final BehaviorSubject<int> friendApplyNum = BehaviorSubject<int>.seeded(0);

  Timer _timerPerMinute;

  @override
  void init() {
    super.init();
    webSocketClient.connect();
    _timerPerMinuteCallback(null);
    _timerPerMinute =
        Timer.periodic(const Duration(minutes: 1), _timerPerMinuteCallback);
  }

  @override
  void dispose() {
    super.dispose();
    webSocketClient.close();
    currentIndex.close();
    pageController.dispose();
    _timerPerMinute.cancel();
  }

  void _timerPerMinuteCallback(Timer timer) {
    _refreshUserProfile();
    _refreshFriendApplyNum();
  }

  void _refreshUserProfile() =>
      _authRepository.getSelfInfo().catchError((Object error) {});

  // TODO(windrunner): 【不重要】若onError内出错，比如onError: (Error e) {}，e不是Object会报错，会同时导致报一个WorkerTask<Object, String>不是Task<String, Map<String, dynamic>>的错误，原因可能在ThrowErrorInterceptor，需要看chopper的处理了
  void _refreshFriendApplyNum() => _userFriendApplyRepository
      .getFriendApplyList(page: 1, limit: 1, state: FriendApplyState.waiting)
      .then((FriendApplyList result) => friendApplyNum.value = result.total,
          onError: (_) {});
}
