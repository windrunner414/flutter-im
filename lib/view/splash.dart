import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat/util/screen.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(
        const <SystemUiOverlay>[SystemUiOverlay.bottom]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    dependOnScreenUtil(context);
    return GestureDetector(
      onTap: () => print('点击了启动屏'),
      child: Container(
        child: const Text('启动屏'),
      ),
    );
  }
}
