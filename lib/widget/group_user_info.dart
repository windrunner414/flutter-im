import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group_user.dart';

typedef GroupUserInfoBuilder = Widget Function(
    BuildContext context, GroupUser user);

class GroupUserInfo extends StatefulWidget {
  const GroupUserInfo({
    @required this.userId,
    @required this.builder,
    @required this.userList,
  });

  final int userId;
  final GroupUserInfoBuilder builder;
  final BehaviorSubject<GroupUserList> userList;

  @override
  _GroupUserInfoState createState() => _GroupUserInfoState();
}

class _GroupUserInfoState extends State<GroupUserInfo> {
  StreamSubscription _subscription;
  GroupUser _lastInfo;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _lastInfo);
  }

  GroupUser _findInfo() {
    final List<GroupUser> list = widget.userList.value.list;
    for (var i in list) {
      if (i.userId == widget.userId) {
        return i;
      }
    }
    if (widget.userId == ownUserInfo.value.userId) {
      return GroupUser(
        userAvatar: ownUserInfo.value.userAvatar,
        userName: ownUserInfo.value.userName,
        userId: widget.userId,
      );
    } else {
      return GroupUser(
        userAvatar: '',
        userName: '用户${widget.userId}',
        userId: widget.userId,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _lastInfo = _findInfo();
    _subscription = widget.userList.skip(1).listen((value) {
      final GroupUser u = _findInfo();
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
  void didUpdateWidget(GroupUserInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _lastInfo = _findInfo();
    }
  }
}
