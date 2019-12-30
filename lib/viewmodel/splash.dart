import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wechat/viewmodel/base.dart';

class SplashViewModel extends BaseViewModel {
  @override
  void init() {
    super.init();
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    }
  }
}
