import 'package:flutter/material.dart';

bool _wantKeepAlive() => true;

class AutomaticKeepAliveWidget extends StatefulWidget {
  final Widget child;
  final bool Function() wantKeepAlive;

  AutomaticKeepAliveWidget({this.child, this.wantKeepAlive = _wantKeepAlive})
      : assert(child != null),
        assert(wantKeepAlive != null);

  @override
  _AutomaticKeepAliveWidgetState createState() =>
      _AutomaticKeepAliveWidgetState();
}

class _AutomaticKeepAliveWidgetState extends State<AutomaticKeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.wantKeepAlive();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
