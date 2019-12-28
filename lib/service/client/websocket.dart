part of '../base.dart';

class WebSocketClient {
  final String url;
  final List<String> protocols;
  final Map<String, dynamic> headers;

  WebSocketClient({this.url, this.protocols, this.headers});

  Future<void> connect() async {}
}
