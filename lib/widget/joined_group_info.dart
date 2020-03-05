import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wechat/common/state.dart';
import 'package:wechat/model/group.dart';
import 'package:wechat/widget/stream_builder.dart';

typedef GroupInfoBuilder = Widget Function(BuildContext context, Group group);

class JoinedGroupInfo extends StatefulWidget {
  const JoinedGroupInfo({@required this.groupId, @required this.builder});

  final int groupId;
  final GroupInfoBuilder builder;

  @override
  _JoinedGroupInfoState createState() => _JoinedGroupInfoState();
}

class _JoinedGroupInfoState extends State<JoinedGroupInfo> {
  Widget _cached;
  Group _lastInfo;

  @override
  Widget build(BuildContext context) {
    return IStreamBuilder(
      stream: groupList,
      builder: _build,
    );
  }

  Widget _build(BuildContext context, _) {
    bool equal(Group g1, Group g2) {
      if (g1 == g2) {
        return true;
      }
      if (g1 == null || g2 == null) {
        return false;
      }
      return jsonEncode(g1) == jsonEncode(g2);
    }

    final g = findGroupInfoInJoinedGroup(widget.groupId);
    if (_cached != null && equal(_lastInfo, g)) {
      return _cached;
    }
    _lastInfo = g;
    if (g != null) {
      _cached = widget.builder(context, g);
    } else {
      _cached = widget.builder(
        context,
        Group(
          groupAvatar: '',
          groupName: '群聊${widget.groupId}',
          groupId: widget.groupId,
        ),
      );
    }
    return _cached;
  }

  @override
  void didUpdateWidget(JoinedGroupInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groupId != widget.groupId ||
        oldWidget.builder != widget.builder) {
      _cached = null;
      _lastInfo = null;
    }
  }
}
