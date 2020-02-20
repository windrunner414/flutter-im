import 'dart:async';

import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/viewmodel/base.dart';

class HomeViewModel extends BaseViewModel {
  final AuthRepository _authRepository = inject();
  final UserFriendApplyRepository _userFriendApplyRepository = inject();

  final BehaviorSubject<int> currentIndex = BehaviorSubject<int>.seeded(0);
  final PageController pageController = PageController(initialPage: 0);
  final BehaviorSubject<int> friendApplicationNum =
      BehaviorSubject<int>.seeded(0);

  final Set<Timer> _timers = <Timer>{};

  @override
  void init() {
    super.init();
    webSocketClient.connect(
        webSocketBaseUrl + '/?userSession=' + ownUserInfo.value.userSession);
    _startTimers();
  }

  @override
  void dispose() {
    super.dispose();
    webSocketClient.close();
    currentIndex.close();
    pageController.dispose();
    _stopTimers();
  }

  void _startTimers() {
    _refreshUserProfile();
    _refreshFriendApplyNum();
    _timers.add(Timer.periodic(
        const Duration(minutes: 5), (_) => _refreshUserProfile()));
    // TODO(windrunner): 应该做一个Event Util，支持register/unregister/trigger事件并传参，在这里register刷新onFriendApplyNumUpdate事件处理，verify申请后trigger
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshFriendApplyNum()));
  }

  void _stopTimers() {
    _timers.removeWhere((Timer timer) {
      timer.cancel();
      return true;
    });
  }

  void _refreshUserProfile() =>
      _authRepository.getSelfInfo().catchError((Object error) {});

  // TODO(windrunner): 【不重要】若onError内出错，比如onError: (Error e) {}，e不是Object会报错，会同时导致报一个WorkerTask<Object, String>不是Task<String, Map<String, dynamic>>的错误，原因可能在ThrowErrorInterceptor，需要看chopper的处理了
  void _refreshFriendApplyNum() => _userFriendApplyRepository
      .getFriendApplicationList(
          page: 1, limit: 1, state: FriendApplicationState.waiting)
      .then(
          (FriendApplicationList result) =>
              friendApplicationNum.value = result.total,
          onError: (Object error) {});
}
