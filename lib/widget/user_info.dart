import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/user.dart';
import 'package:wechat/widget/stream_builder.dart';

typedef UserInfoBuilder = Widget Function(BuildContext context, User user);

class UserInfo extends StatefulWidget {
  const UserInfo({@required this.userId, @required this.builder});

  final int userId;
  final UserInfoBuilder builder;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  Widget _cached;
  User _lastInfo = null;

  @override
  Widget build(BuildContext context) {
    if (widget.userId == ownUserInfo.value.userId) {
      return IStreamBuilder(
        stream: ownUserInfo,
        builder: (BuildContext context, _) =>
            widget.builder(context, ownUserInfo.value),
      );
    } else {
      return IStreamBuilder(
        stream: cachedUser,
        builder: _build,
      );
    }
  }

  Widget _build(BuildContext context, _) {
    bool equal(User u1, User u2) {
      if (u1 == u2) {
        return true;
      }
      if (u1 == null || u2 == null) {
        return false;
      }
      return u1.userName == u2.userName &&
          u1.userAvatar == u2.userAvatar &&
          u1.userId == u2.userId;
    }

    final u = findUserInfoInCache(widget.userId);
    if (_cached != null && equal(_lastInfo, u)) {
      return _cached;
    }
    _lastInfo = u;
    if (u != null) {
      _cached = widget.builder(context, u);
    } else {
      _cached = widget.builder(
        context,
        User(
          userAvatar: '',
          userName: '用户${widget.userId}',
          userId: widget.userId,
        ),
      );
    }
    return _cached;
  }

  @override
  void didUpdateWidget(UserInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId ||
        oldWidget.builder != widget.builder) {
      _cached = null;
      _lastInfo = null;
    }
  }
}
