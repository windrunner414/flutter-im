import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:dartin/dartin.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/exception.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/friend_application.dart';
import 'package:wechat/model/group_application.dart';
import 'package:wechat/model/message.dart';
import 'package:wechat/model/websocket_message.dart';
import 'package:wechat/repository/auth.dart';
import 'package:wechat/repository/group.dart';
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
  final GroupRepository _groupRepository = inject();

  final BehaviorSubject<int> currentIndex = BehaviorSubject<int>.seeded(0);
  final PageController pageController = PageController(initialPage: 0);
  final BehaviorSubject<int> friendApplicationNum =
      BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> groupApplicationNum =
      BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<int> groupInvitationNum =
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
        assert(() {
          debugPrint('webSocket已连接');
          return true;
        }());
        webSocketConnected.value = true;
        _messageRepository.pullUnreadMessages().catchError((Object error) {
          if (error is Response && error.statusCode == 401) {
            return;
          }
          assert(() {
            debugPrint('获取未读消息失败，重连：$error');
            return true;
          }());
          webSocketClient.reconnect();
        });
      } else if (event.type == WebSocketEventType.closed) {
        assert(() {
          debugPrint('webSocket已断开');
          return true;
        }());
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
    friendApplicationNum.close();
    webSocketConnected.close();
    _stopTimers();
  }

  void _startTimers() {
    _refreshUserProfile();
    _refreshFriendApplyNum();
    _refreshFriendList();
    _refreshJoinedGroupList();
    _refreshGroupApplyNum();
    _timers.add(Timer.periodic(
        const Duration(minutes: 5), (_) => _refreshUserProfile()));
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshFriendApplyNum()));
    _timers.add(Timer.periodic(const Duration(seconds: 15), (_) => _ping()));
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshFriendList()));
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshJoinedGroupList()));
    _timers.add(Timer.periodic(
        const Duration(seconds: 5), (_) => _refreshGroupApplyNum()));
  }

  void _stopTimers() {
    _timers.removeWhere((Timer timer) {
      timer.cancel();
      return true;
    });
  }

  void _refreshJoinedGroupList() =>
      _groupRepository.getJoined().catchError((Object error) {});

  void _refreshFriendList() =>
      _userFriendRepository.getAll().catchError((Object error) {});

  void _refreshUserProfile() =>
      _authRepository.getSelfInfo().catchError((Object error) {});

  void _refreshFriendApplyNum() {
    _userFriendApplyRepository
        .getFriendApplicationList(
            page: 1, limit: 1, state: FriendApplicationState.waiting)
        .bindTo(this, 'refreshFriendApplyNum')
        .then((FriendApplicationList result) =>
            friendApplicationNum.value = result.total)
        .catchError((Object e) {});
  }

  void _refreshGroupApplyNum() {
    _groupRepository
        .getGroupApplications(
            page: 1, limit: 1, state: GroupApplicationState.waiting)
        .bindTo(this, 'refreshGroupApplyNum')
        .then((GroupApplicationList result) =>
            groupApplicationNum.value = result.total)
        .catchError((Object e) {});
  }

  void _refreshGroupInvitationNum() {}

  Future<void> _ping() async {
    /// 如果此时连接断开，会立刻失败并调用reconnect，reconnect不会做任何事情
    try {
      await webSocketClient
          .sendAndReceive<dynamic>(
            WebSocketMessage<dynamic>(op: 0, msg: 'ping'),
            const Duration(seconds: 10),
          )
          .bindTo(this, 'ping');
    } catch (e) {
      if (e is CancelException ||
          (e is WebSocketMessage &&
              e.op == -1001 &&
              e.msgType == MessageType.text &&
              e.flagId != null &&
              e.args == null &&
              e.msg == "action  not found")) {
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
