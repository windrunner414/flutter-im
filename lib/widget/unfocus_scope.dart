import 'package:flutter/cupertino.dart';

class UnFocusScope extends StatelessWidget {
  const UnFocusScope({this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: child,
      );
}
