import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';

typedef GroupInfoBuilder = Widget Function(BuildContext context, Group group);

class JoinedGroupInfo extends StatefulWidget {
  const JoinedGroupInfo({@required this.groupId, @required this.builder});

  final int groupId;
  final GroupInfoBuilder builder;

  @override
  _JoinedGroupInfoState createState() => _JoinedGroupInfoState();
}

class _JoinedGroupInfoState extends State<JoinedGroupInfo> {
  StreamSubscription _subscription;
  Group _lastInfo;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _lastInfo ??
          Group(
            groupAvatar: '',
            groupName: '群聊${widget.groupId}',
            groupId: widget.groupId,
          ),
    );
  }

  @override
  void initState() {
    super.initState();
    _lastInfo = findGroupInfoInJoinedGroup(widget.groupId);
    _subscription = joinedGroupList.skip(1).listen((value) {
      final Group g = findGroupInfoInJoinedGroup(widget.groupId);
      if (g != _lastInfo) {
        setState(() {
          _lastInfo = g;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  void didUpdateWidget(JoinedGroupInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groupId != widget.groupId) {
      _lastInfo = findGroupInfoInJoinedGroup(widget.groupId);
    }
  }
}
