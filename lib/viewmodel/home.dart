import 'dart:async';
import 'dart:convert';

import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/message.dart';
import 'package:wechat/repository/user_friend.dart';
import 'package:wechat/repository/user_friend_apply.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/service/client/websocket.dart';
import 'package:wechat/viewmodel/base.dart';

class HomeViewModel extends BaseViewModel {
  final AuthRepository _authRepository = inject();
  final UserFriendApplyRepository _userFriendApplyRepository = inject();
  final UserFriendRepository _userFriendRepository = inject();
  final MessageRepository _messageRepository = inject();

  final BehaviorSubject<int> currentIndex = BehaviorSubject<int>.seeded(0);
  final PageController pageController = PageController(initialPage: 0);
  final BehaviorSubject<int> friendApplicationNum =
      BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<bool> webSocketConnected =
      BehaviorSubject<bool>.seeded(false);

  final Set<Timer> _timers = <Timer>{};

  @override
  void init() {
    super.init();
    webSocketClient.connect(
        webSocketBaseUrl + '/?userSession=' + ownUserInfo.value.userSession);
    webSocketClient.connection.listen((WebSocketEvent event) {
      if (event.type == WebSocketEventType.connected) {
        webSocketConnected.value = true;
        _messageRepository.pullUnreadMessages();
      } else if (event.type == WebSocketEventType.closed) {
        webSocketConnected.value = false;
      }
    });
    _messageRepository.initConversationList();
    _startTimers();
  }

  @override
  void dispose() {
    super.dispose();
    webSocketClient.close();
    currentIndex.close();
    pageController.dispose();
    _messageRepository.disposeConversationList();
    _stopTimers();
  }

  void _startTimers() {
    _refreshUserProfile();
    _refreshFriendApplyNum();
    _refreshFriendList();
    _timers.add(Timer.periodic(
        const Duration(minutes: 5), (_) => _refreshUserProfile()));
    // TODO(windrunner): 应该做一个Event Util，支持register/unregister/trigger事件并传参，在这里register刷新onFriendApplyNumUpdate事件处理，verify申请后trigger
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshFriendApplyNum()));
    _timers.add(Timer.periodic(const Duration(seconds: 10), (_) => _ping()));
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshFriendList()));
  }

  void _stopTimers() {
    _timers.removeWhere((Timer timer) {
      timer.cancel();
      return true;
    });
  }

  void _refreshFriendList() =>
      _userFriendRepository.getAll().catchError((Object error) {});

  void _refreshUserProfile() =>
      _authRepository.getSelfInfo().catchError((Object error) {});

  // TODO(windrunner): 【不重要】若onError内出错，比如onError: (Error e) {}，e不是Object会报错，会同时导致报一个WorkerTask<Object, String>不是Task<String, Map<String, dynamic>>的错误，原因可能在ThrowErrorInterceptor，需要看chopper的处理了
  void _refreshFriendApplyNum() {
    _userFriendApplyRepository
        .getFriendApplicationList(
            page: 1, limit: 1, state: FriendApplicationState.waiting)
        .then((FriendApplicationList result) =>
            friendApplicationNum.value = result.total)
        .catchError((Object e) {});
  }

  Future<void> _ping() async {
    /// 如果此时连接断开，会立刻失败并调用reconnect，reconnect不会做任何事情
    try {
      await webSocketClient.sendAndReceive<dynamic>(
          WebSocketMessage<dynamic>(op: 0, msg: 'ping'));
    } catch (e) {
      if (e is WebSocketMessage &&
          e.op == -1001 &&
          e.msgType == MessageType.text &&
          e.flagId != null &&
          e.args == null &&
          e.msg == "action  not found") {
        // TODO: ping发了json，服务端返回action  not found
        return;
      }
      if (active) {
        assert(() {
          debugPrint('重连：${jsonEncode(e)}');
          return true;
        }());
        webSocketClient.reconnect();
      }
    }
  }
}
