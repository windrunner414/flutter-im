import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage(this.url);

  final String url;

  @override
  Widget build(BuildContext context) => WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url,
      );
}
