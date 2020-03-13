import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/widget/stream_builder.dart';

typedef UserInfoBuilder = Widget Function(BuildContext context, User user);

class FriendUserInfo extends StatefulWidget {
  const FriendUserInfo({@required this.userId, @required this.builder});

  final int userId;
  final UserInfoBuilder builder;

  @override
  _FriendUserInfoState createState() => _FriendUserInfoState();
}

class _FriendUserInfoState extends State<FriendUserInfo> {
  StreamSubscription _subscription;
  User _lastInfo;

  @override
  Widget build(BuildContext context) {
    if (widget.userId == ownUserInfo.value.userId) {
      return IStreamBuilder(
        stream: ownUserInfo,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) =>
            widget.builder(context, snapshot.data),
      );
    } else {
      return widget.builder(
        context,
        _lastInfo ??
            User(
              userAvatar: '',
              userName: '用户${widget.userId}',
              userId: widget.userId,
            ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.userId == ownUserInfo.value.userId) {
      return;
    }
    _lastInfo = findUserInfoInFriendList(widget.userId);
    _subscription = friendList.skip(1).listen((value) {
      final User u = findUserInfoInFriendList(widget.userId);
      if (u != _lastInfo) {
        setState(() {
          _lastInfo = u;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  void didUpdateWidget(FriendUserInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      if (widget.userId == ownUserInfo.value.userId) {
        _lastInfo = null;
      } else {
        _lastInfo = findUserInfoInFriendList(widget.userId);
      }
    }
  }
}
