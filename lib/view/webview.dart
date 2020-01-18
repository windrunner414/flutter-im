import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wechat/common/constant.dart';
import 'package:wechat/common/route.dart';
import 'package:wechat/util/layer.dart';
import 'package:wechat/widget/app_bar.dart';
import 'package:wechat/widget/stream_builder.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage(this.url);

  final String url;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;
  final BehaviorSubject<double> _loadingProgress =
      BehaviorSubject<double>.seeded(0);
  final BehaviorSubject<String> _title = BehaviorSubject<String>.seeded('');

  Timer _addLoadingProgressTimer;
  final Random _random = Random();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: IAppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            onPressed: () => router.pop(),
          ),
          title: IStreamBuilder<String>(
            stream: _title,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                Text(snapshot.data),
          ),
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: _onWebViewCreated,
                      onPageStarted: _onPageStarted,
                      onPageFinished: _onPageFinished,
                      navigationDelegate: _navigationDelegate,
                    ),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) =>
                              IStreamBuilder<double>(
                        stream: _loadingProgress,
                        builder: (BuildContext context,
                                AsyncSnapshot<double> snapshot) =>
                            Container(
                          width: constraints.maxWidth * snapshot.data,
                          height: 3,
                          color: const Color(AppColor.LoginInputActiveColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Future<NavigationDecision> _navigationDelegate(
      NavigationRequest request) async {
    if (request.url.startsWith('http://') ||
        request.url.startsWith('https://')) {
      return NavigationDecision.navigate;
    } else {
      return NavigationDecision.prevent;
    }
  }

  Future<bool> _onWillPop() async {
    if (_controller == null) {
      return true;
    }
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false;
    } else {
      return true;
    }
  }

  void _onWebViewCreated(WebViewController controller) {
    _controller = controller;
    try {
      controller.loadUrl(widget.url);
    } catch (error) {
      showToast('加载失败');
    }
  }

  void _onPageStarted(String url) {
    _loadingProgress.value = 0;
    _startAddLoadingProgress();
  }

  void _onPageFinished(String url) {
    _controller.getTitle().then((String title) => _title.value = title);
    final double nowProgress = _loadingProgress.value;
    final double addProgress = 1 - nowProgress;
    _addLoadingProgress(
      15,
      addProgress,
      () => _addLoadingProgressTimer = Timer(
        const Duration(milliseconds: 10),
        () {
          _loadingProgress.value = 0;
          _addLoadingProgressTimer = null;
        },
      ),
    );
  }

  void _startAddLoadingProgress() {
    final int tickNum = (_random.nextInt(300) + 30) ~/ 10;
    final double nowProgress = _loadingProgress.value;
    final double addProgress = _random.nextDouble() % ((1 - nowProgress) / 5);
    _addLoadingProgress(tickNum, addProgress, _startAddLoadingProgress);
  }

  void _addLoadingProgress(
      int tickNum, double addProgress, VoidCallback endCallback) {
    final double nowProgress = _loadingProgress.value;
    _addLoadingProgressTimer?.cancel();
    _addLoadingProgressTimer =
        Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      final int nowTickNum = timer.tick.clamp(0, tickNum).toInt();
      _loadingProgress.value =
          nowProgress + addProgress * (nowTickNum / tickNum);
      if (nowTickNum == tickNum) {
        timer.cancel();
        _addLoadingProgressTimer = null;
        endCallback();
      }
    });
  }
}
