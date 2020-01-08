import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wechat/service/base.dart';
import 'package:wechat/viewmodel/base.dart';

class HomeViewModel extends BaseViewModel {
  final BehaviorSubject<int> currentIndex = BehaviorSubject<int>.seeded(0);
  final PageController pageController = PageController(initialPage: 0);

  @override
  void init() {
    super.init();
    webSocketClient.connect();
  }

  @override
  void dispose() {
    super.dispose();
    webSocketClient.close();
    currentIndex.close();
    pageController.dispose();
  }
}
